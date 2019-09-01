import Config

config :no_slice,
  ecto_repos: [NoSlice.Repository]

# Configures the endpoint
config :no_slice, NoSliceWeb.Endpoint,
  http: [port: 8080],
  url: [host: System.get_env("APP_HOST")],
  secret_key_base: System.get_env("APP_SECRET"),
  render_errors: [view: NoSliceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: NoSlice.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure your database
config :no_slice, NoSlice.Repository,
  port: System.get_env("DATABASE_PORT"),
  hostname: System.get_env("DATABASE_HOST"),
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD"),
  pool_size: 15,
  ssl: false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure JWTs secret
config :joken, default_signer: System.get_env("APP_SECRET")

# Import environment specific config.
import_config "#{Mix.env()}.exs"
