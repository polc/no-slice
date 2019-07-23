defmodule BioWeb.Plug.DecodeToken do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn
  alias Bio.Accounts.Dataloader
  alias Bio.Accounts.Schemas.User
  alias BioWeb.Security.AuthenticationToken

  def init(opts), do: opts

  def call(conn, _) do
    handle_authorization_header(conn, get_req_header(conn, "authorization"))
  end

  def handle_authorization_header(conn, ["Bearer " <> token]) do
    with {:ok, %{"user_id" => user_id}} <- AuthenticationToken.verify_and_validate(token),
         %User{} = user <- Dataloader.find_user(user_id)
    do
      conn
      |> assign(:user, user)
      |> assign(:token, token)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{ message: "Unauthorized." })
        |> halt
    end
  end

  def handle_authorization_header(conn, _) do
    conn
  end
end






















