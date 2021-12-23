defmodule Providers.ResponseMatcher do
  @moduledoc """
  Tesla middleware used to translate API responses in a standard manner.

  Note: Sice it alters the format of the method response
  (`{:ok, body}` instead of `{:ok, %Tesla.Env{}}`) it must be included as the
  first middleware in the list in the target client, otherwise it can interfere with
  other middleware functionality.

  """
  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> match_response()
  end

  defp match_response({:ok, %{status: status, body: body}})
       when status < 300 and status >= 200,
       do: {:ok, body}

  defp match_response({:ok, %{status: status, body: body}}),
    do: {:error, {status, body}}

  defp match_response(err = {:error, _}), do: err
end
