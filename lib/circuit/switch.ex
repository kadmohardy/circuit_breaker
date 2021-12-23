defmodule Circuit.Switch do
  use GenStateMachine, callback_mode: :state_functions

  alias Providers.Mockoon
  alias Providers.MockoonTwo

  @name :circuit_breaker_switch
  @error_count_limit 3
  @time_to_half_open_delay 8000

  def start_link(_state) do
    GenStateMachine.start_link(__MODULE__, {:closed, %{error_count: 0}}, name: @name)
  end

  def get_user(id) do
    GenStateMachine.call(@name, {:get_user, id})
  end

  @spec closed({:call, any}, {:get_user, binary}, any) ::
          {:keep_state, %{:error_count => number, optional(any) => any},
           {:reply, any, {:error, any} | {:ok, any}}}
          | {:next_state, :open, any, {:reply, any, {:error, any}}}
  def closed({:call, from}, {:get_user, id}, data) do
    case Mockoon.get_user(id) do
      {:ok, user} ->
        {:keep_state, %{error_count: 0}, {:reply, from, {:ok, user}}}

      {:error, reason} ->
        handle_error(reason, from, %{data | error_count: data.error_count + 1})
    end
  end

  @spec half_open({:call, any}, {:get_user, binary}, any) ::
          {:next_state, :closed | :open, any, {:reply, any, {:error, any} | {:ok, any}}}
  def half_open({:call, from}, {:get_user, id}, data) do
    case Mockoon.get_user(id) do
      {:ok, user} ->
        {:next_state, :closed, %{count_error: 0}, {:reply, from, {:ok, user}}}

      {:error, reason} ->
        open_circuit(from, data, reason, @time_to_half_open_delay)
    end
  end

  ######################################################################
  #### OPEN
  #### 1. whithout secondary partner - uncomment bellow code line 51
  #### 2. using secondary partner - comment code 56
  ######################################################################

  # def open({:call, from}, {:get_user, id}, data) do
  #   response = MockoonTwo.get_user(id)
  #   {:keep_state, data, {:reply, from, response}}
  # end

  def open({:call, from}, {:get_user, _id}, data) do
    {:keep_state, data, {:reply, from, {:error, :circuit_open}}}
  end

  def open(:info, :to_half_open, data) do
    {:next_state, :half_open, data}
  end

  # Verify error rate and decides about next state
  defp handle_error(reason, from, data = %{error_count: error_count})
       when error_count > @error_count_limit do
    open_circuit(from, data, reason, @time_to_half_open_delay)
  end

  defp handle_error(reason, from, data) do
    {:keep_state, data, {:reply, from, {:error, reason}}}
  end

  defp open_circuit(from, data, reason, delay) do
    # Set to half open after delay
    Process.send_after(@name, :to_half_open, delay)

    # Set current state to open
    {:next_state, :open, data, {:reply, from, {:error, reason}}}
  end
end
