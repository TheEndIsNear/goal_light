# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :goal_light_ui, GoalLightUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W+TzaUrYOdoiz0KcQMHySkmo+WoojsOM+UDzbAv0FTxgFV08H6/d7BytxS01uj/6",
  render_errors: [view: GoalLightUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GoalLightUi.PubSub,
  live_view: [signing_salt: "icMWFR9c"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
