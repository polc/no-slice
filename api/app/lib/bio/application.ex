defmodule Bio.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Bio.Repository,
      BioWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Bio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
