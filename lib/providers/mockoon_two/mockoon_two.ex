defmodule Providers.MockoonTwo do
  alias Providers.MockoonTwo.Client
  require Logger

  @doc """
  Gets open support tickets for banking platform from freshdesk api
  """

  @url "user/"

  def get_user(id) do
    response =
      (@url <> id)
      |> Client.get()
      |> match_response()

    response
  end

  defp match_response({:ok, %{status: status, body: body}})
       when status < 300 and status >= 200,
       do: {:ok, body}

  defp match_response(response = {:ok, _body}), do: response

  defp match_response({:error, %{status: status, body: body}}),
    do: {:error, {status, body}}

  defp match_response(err = {:error, _}), do: err
end
