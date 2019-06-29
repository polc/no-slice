# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bio,
  ecto_repos: [Bio.Repository]

# Configures the endpoint
config :bio, BioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("APP_SECRET"),
  render_errors: [view: BioWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bio.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure your database
config :bio, Bio.Repository,
  port: System.get_env("DATABASE_PORT"),
  hostname: System.get_env("DATABASE_HOST"),
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure JWTs secret
config :joken, default_signer: System.get_env("APP_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
