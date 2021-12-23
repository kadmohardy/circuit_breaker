# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :circuit,
  ecto_repos: [Circuit.Repo]

# Configures the endpoint
config :circuit, CircuitWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CircuitWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Circuit.PubSub,
  live_view: [signing_salt: "A0U/wVaV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :circuit, Providers.Mockoon.Client, base_url: "http://localhost:3001"

config :circuit, Providers.MockoonTwo.Client, base_url: "http://localhost:3002"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
