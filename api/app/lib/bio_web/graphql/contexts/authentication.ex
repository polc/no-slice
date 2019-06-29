defmodule BioWeb.GraphQL.Contexts.Authentication do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn
  alias Bio.Accounts.Dataloader
  alias Bio.Accounts.Schemas.User
  alias BioWeb.Security.AuthenticationToken

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{"user_id" => user_id}} <- AuthenticationToken.verify_and_validate(token),
         %User{} = user <- Dataloader.find_user(user_id) do
      %{user: user, token: token}
    else
      _ -> %{}
    end
  end
end
