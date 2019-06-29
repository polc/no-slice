defmodule BioWeb.GraphQL.Types.Accounts do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias BioWeb.Security.AuthenticationToken

  import_types(BioWeb.GraphQL.UUID4)
  import_types(BioWeb.GraphQL.Error)

  object(:viewer) do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  node object(:user) do
    field :email, :string
    field :first_name, :string
    field :account, non_null(:account), resolve: dataloader(Bio.Accounts.Dataloader)
  end

  node object(:account) do
    field :type, :string
    field :users, non_null(list_of(:user)), resolve: dataloader(Bio.Accounts.Dataloader)
  end

  object :accounts_queries do
    field :viewer, :viewer do
      middleware(BioWeb.GraphQL.Middlewares.Authentication)

      resolve(fn
        _, _, %{context: %{user: user, token: token}} ->
          {:ok, %{user: user, token: token}}
      end)
    end
  end

  object :accounts_mutations do
    payload field :create_token do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
      end

      output do
        field :result, :viewer
        field :errors, list_of(:error)
      end

      resolve(fn
        %{email: email, password: password}, _ ->
          user = Bio.Accounts.Dataloader.find_user_by_email(email)

          case Bcrypt.check_pass(user, password) do
            {:ok, _} ->
              token = AuthenticationToken.generate_and_sign!(%{"user_id" => user.id})
              {:ok, %{result: %{user: user, token: token}}}

            {:error, _} ->
              {:ok, %{errors: [%{property: "email", message: "Invalid email or password."}]}}
          end
      end)
    end

    payload field :create_account do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
        field :first_name, non_null(:string)
      end

      output do
        field :result, :account
        field :errors, list_of(:error)
      end

      resolve(fn
        input, _ ->
          Bio.Accounts.UseCases.CreateAccount.call(input)
          |> Bio.Repository.transaction()
          |> case do
            {:ok, %{account: account}} ->
              {:ok, %{result: account}}

            {:error, _, changeset, _} ->
              {:ok, %{errors: BioWeb.GraphQL.Error.changeset_to_errors(changeset)}}
          end
      end)
    end
  end
end
