use Mix.Config

config :bio, BioWeb.Endpoint,
  http: [:inet6, port: 8080],
  url: [host: "example.com", port: 80],
  secret_key_base: System.get_env("APP_SECRET")

# Configure database
config :bio, Bio.Repository,
  pool_size: 15,
  ssl: true

# Do not print debug messages in production
config :logger, level: :info
