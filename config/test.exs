use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :harvest_dashboard, HarvestDashboardWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :harvest_dashboard, HarvestDashboard.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "harvest_dashboard_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
