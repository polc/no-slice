defmodule BioWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bio

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug BioWeb.Plug.Router
end
