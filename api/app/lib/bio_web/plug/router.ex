defmodule BioWeb.Plug.Router do
  use BioWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug

    plug BioWeb.Plug.DecodeToken
    plug BioWeb.Plug.BuildContext
  end

  scope "/" do
    pipe_through(:api)

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BioWeb.GraphQL.Schema, json_codec: Jason
    forward "/graphql", Absinthe.Plug, schema: BioWeb.GraphQL.Schema, json_codec: Jason
  end
end
