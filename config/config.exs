# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :harvest_dashboard,
  ecto_repos: [HarvestDashboard.Repo]

# Configures the endpoint
config :harvest_dashboard, HarvestDashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sBwNcTBhUsfEbmLQB1QPix4tVz7zBMHgVdlJrf2pNPzktgCAiq7CblNRKDrelTPl",
  render_errors: [view: HarvestDashboardWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HarvestDashboard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
