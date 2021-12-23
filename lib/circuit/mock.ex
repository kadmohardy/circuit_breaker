defmodule Circuit.Mock do
  alias Providers.Mockoon
  alias Circuit.Switch

  def get_user(id) do
    id
    |> Switch.get_user()
    |> case do
      {:ok, user} ->
        {:ok, Map.new(user, fn {k, v} -> {String.to_atom(k), v} end)}

      {:error, :circuit_open} ->
        {:error, :service_unavailable}

      {:error, :econnrefused} ->
        {:error, :internal_server_error}

      error ->
        IO.inspect(error)
        error
    end
  end
end
