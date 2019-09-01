defmodule NoSliceWeb.GraphQL.Middlewares.Authentication do
  @moduledoc false
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{user: _, token: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Not authenticated."})
    end
  end
end
