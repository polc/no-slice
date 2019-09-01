defmodule NoSlice.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      NoSlice.Repository,
      NoSliceWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: NoSlice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    NoSliceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
