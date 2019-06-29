defmodule Bio.Accounts.Schemas.User do
  @moduledoc """
  The users schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :password_hash, :string
    timestamps()

    belongs_to :account, Bio.Accounts.Schemas.Account
    # has_one :account, Bio.Accounts.Schemas.Account
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :first_name, :password_hash])
    |> validate_required([:email, :first_name, :password_hash])
    |> validate_length(:email, min: 1, max: 254)
    |> validate_length(:first_name, min: 1, max: 254)
    |> unique_constraint(:email)
  end
end
