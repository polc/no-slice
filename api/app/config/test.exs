import Config

# We don't run a server during test.
config :bio, BioWeb.Endpoint, server: false

# Configure your database
config :bio, Bio.Repository,
  database: System.get_env("DATABASE_NAME") <> "_test",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn

# Configure a low security to speed up tests
config :bcrypt_elixir, :log_rounds, 2
