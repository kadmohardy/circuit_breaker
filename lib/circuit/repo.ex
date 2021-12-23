defmodule Circuit.Repo do
  use Ecto.Repo,
    otp_app: :circuit,
    adapter: Ecto.Adapters.Postgres
end
