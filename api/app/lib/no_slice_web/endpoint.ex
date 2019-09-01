defmodule NoSliceWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :no_slice

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug NoSliceWeb.Plug.Router
end
