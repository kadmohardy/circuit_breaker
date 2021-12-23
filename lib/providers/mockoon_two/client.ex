defmodule Providers.MockoonTwo.Client do
  @moduledoc """
  HTTP Client for Freshdesk APIs.
  """
  use Tesla

  plug(Providers.ResponseMatcher)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, base_url())

  defp base_url, do: Keyword.fetch!(config(), :base_url)
  defp config, do: Application.fetch_env!(:circuit, __MODULE__)
end
