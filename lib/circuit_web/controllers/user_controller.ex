defmodule CircuitWeb.UserController do
  use CircuitWeb, :controller

  alias Circuit.Mock
  action_fallback(CircuitWeb.FallbackController)

  def get(conn, %{"id" => id}) do
    with {:ok, user} <- Mock.get_user(id) do
      render(conn, "show.json", user: user)
    end
  end
end
