defmodule NoSliceWeb.GraphQL.Types.Accounts do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias NoSliceWeb.Security.AuthenticationToken

  import_types(NoSliceWeb.GraphQL.UUID4)
  import_types(NoSliceWeb.GraphQL.Error)

  object(:viewer) do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  node object(:user) do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :account, non_null(:account), resolve: dataloader(NoSlice.Accounts.Dataloader)
  end

  node object(:account) do
    field :type, non_null(:string)
    field :users, non_null(list_of(:user)), resolve: dataloader(NoSlice.Accounts.Dataloader)
  end

  object :accounts_queries do
    field :viewer, :viewer do
      middleware(NoSliceWeb.GraphQL.Middlewares.Authentication)

      resolve(fn
        _, _, %{context: %{user: user, token: token}} ->
          {:ok, %{user: user, token: token}}
      end)
    end
  end

  object :accounts_mutations do
    payload field :create_account do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
        field :first_name, non_null(:string)
      end

      output do
        field :result, :viewer
        field :errors, list_of(:error)
      end

      resolve(fn
        input, _ ->
          input
          |> NoSlice.Accounts.UseCases.CreateAccount.call()
          |> NoSlice.Repository.transaction()
          |> case do
            {:ok, %{user: user}} ->
              token = AuthenticationToken.generate_and_sign!(%{"user_id" => user.id})
              {:ok, %{result: %{user: user, token: token}}}

            {:error, _, changeset, _} ->
              {:ok, %{errors: NoSliceWeb.GraphQL.Error.changeset_to_errors(changeset)}}
          end
      end)
    end

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
          user = NoSlice.Accounts.Dataloader.find_user_by_email(email)

          case Bcrypt.check_pass(user, password) do
            {:ok, _} ->
              token = AuthenticationToken.generate_and_sign!(%{"user_id" => user.id})
              {:ok, %{result: %{user: user, token: token}}}

            {:error, _} ->
              {:ok, %{errors: [%{property: "email", message: "Invalid email or password."}]}}
          end
      end)
    end

    payload field :request_password do
      input do
        field :email, non_null(:string)
      end

      output do
        field :result, :string
        field :errors, list_of(:error)
      end

      resolve(fn
        input, _ ->
          input
          |> NoSlice.Accounts.UseCases.RequestPassword.call()
          |> NoSlice.Repository.transaction()
          |> case do
            {:ok, _} ->
              {:ok, %{result: "success"}}

            {:error, _, changeset, _} ->
              {:ok, %{errors: NoSliceWeb.GraphQL.Error.changeset_to_errors(changeset)}}
          end
      end)
    end

    payload field :change_password do
      input do
        field :id, non_null(:string)
        field :code, non_null(:string)
        field :new_password, non_null(:string)
      end

      output do
        field :result, :string
        field :errors, list_of(:error)
      end

      resolve(fn
        input, _ ->
          input
          |> NoSlice.Accounts.UseCases.ChangePassword.call()
          |> NoSlice.Repository.transaction()
          |> case do
            {:ok, _} ->
              {:ok, %{result: "success"}}

            {:error, _, changeset, _} ->
              {:ok, %{errors: NoSliceWeb.GraphQL.Error.changeset_to_errors(changeset)}}
          end
      end)
    end
  end
end
