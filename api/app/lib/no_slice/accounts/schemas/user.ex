defmodule NoSlice.Accounts.Schemas.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :password_hash, :string
    timestamps(type: :utc_datetime)

    belongs_to :account, NoSlice.Accounts.Schemas.Account
    has_many :password_requests, NoSlice.Accounts.Schemas.PasswordRequest
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :first_name, :password_hash, :account_id])
    |> validate_required([:email, :first_name, :password_hash, :account_id])
    |> validate_length(:email, min: 1, max: 254)
    |> validate_length(:first_name, min: 1, max: 254)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:account_id)
  end
end
