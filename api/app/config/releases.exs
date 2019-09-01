import Config

# Configures the endpoint
config :no_slice, NoSliceWeb.Endpoint,
  url: [host: System.get_env("APP_HOST")],
  secret_key_base: System.get_env("APP_SECRET")

# Configure your database
config :no_slice, NoSlice.Repository,
  port: System.get_env("DATABASE_PORT"),
  hostname: System.get_env("DATABASE_HOST"),
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD")

# Configure JWTs secret
config :joken, default_signer: System.get_env("APP_SECRET")
