import Config

# For development, we disable any cache and enable debugging and code reloading.
config :no_slice, NoSliceWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Configure database
config :no_slice, NoSlice.Repository, pool_size: 10

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n", level: :debug

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
