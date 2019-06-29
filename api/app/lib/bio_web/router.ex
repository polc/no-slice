defmodule BioWeb.Router do
  use BioWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BioWeb.GraphQL.Contexts.Authentication
  end

  scope "/" do
    pipe_through(:api)

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BioWeb.GraphQL.Schema, json_codec: Jason
    forward "/", Absinthe.Plug, schema: BioWeb.GraphQL.Schema, json_codec: Jason
  end
end
