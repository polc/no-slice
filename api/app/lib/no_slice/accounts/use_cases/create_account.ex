defmodule NoSlice.Accounts.UseCases.CreateAccount do
  @moduledoc """
  Create an account and a first tied user.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi

  alias NoSlice.Accounts.Schemas.Account
  alias NoSlice.Accounts.Schemas.User

  embedded_schema do
    field :email, :string
    field :password, :string
    field :first_name, :string
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:email, :password, :first_name])
    |> validate_required([:email, :password, :first_name])
    |> validate_length(:password, min: 7)
  end

  def call(data) do
    Multi.new()
    |> Multi.run(:data, fn _, _ -> validate(data) end)
    |> Multi.run(:account, &create_account/2)
    |> Multi.run(:user, &create_user/2)
  end

  defp validate(data) do
    case changeset(data) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, apply_changes(changeset)}

      changeset ->
        {:error, changeset}
    end
  end

  defp create_account(repo, _) do
    repo.insert(Account.changeset(%Account{}))
  end

  defp create_user(repo, %{data: data, account: account}) do
    repo.insert(
      User.changeset(
        %User{
          account_id: account.id,
          password_hash: Bcrypt.hash_pwd_salt(data.password)
        },
        Map.from_struct(data)
      )
    )
  end
end
