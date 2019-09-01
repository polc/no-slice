defmodule NoSliceWeb.Plug.Router do
  use NoSliceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug

    plug NoSliceWeb.Plug.DecodeToken
    plug NoSliceWeb.Plug.BuildContext
  end

  scope "/" do
    pipe_through(:api)

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NoSliceWeb.GraphQL.Schema,
      json_codec: Jason

    forward "/graphql", Absinthe.Plug, schema: NoSliceWeb.GraphQL.Schema, json_codec: Jason
  end
end
