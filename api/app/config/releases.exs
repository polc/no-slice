import Config

# Configures the endpoint
config :bio, BioWeb.Endpoint,
  url: [host: System.get_env("APP_HOST")],
  secret_key_base: System.get_env("APP_SECRET")

# Configure your database
config :bio, Bio.Repository,
  port: System.get_env("DATABASE_PORT"),
  hostname: System.get_env("DATABASE_HOST"),
  database: System.get_env("DATABASE_NAME"),
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD")

# Configure JWTs secret
config :joken, default_signer: System.get_env("APP_SECRET")
