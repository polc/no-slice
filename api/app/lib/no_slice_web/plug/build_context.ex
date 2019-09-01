defmodule NoSliceWeb.Plug.BuildContext do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn.assigns)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(%{user: user, token: token}) do
    %{user: user, token: token}
  end

  def build_context(_) do
    %{}
  end
end
