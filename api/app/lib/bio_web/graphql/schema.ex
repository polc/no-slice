defmodule BioWeb.GraphQL.Schema do
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias Bio.Accounts

  import_types(BioWeb.GraphQL.Types.Accounts)

  node interface do
    resolve_type(fn
      %Accounts.Schemas.Account{}, _ ->
        :account

      %Accounts.Schemas.User{}, _ ->
        :user

      _, _ ->
        nil
    end)
  end

  query do
    node field do
      resolve(fn
        %{type: :account, id: id}, _ ->
          {:ok, Accounts.Dataloader.find_account(id)}

        %{type: :user, id: id}, _ ->
          {:ok, Accounts.Dataloader.find_user(id)}

        _, _ ->
          {:error, "No resolver yet."}
      end)
    end

    import_fields(:accounts_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Accounts.Dataloader, Accounts.Dataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
