defmodule NoSlice.Accounts.Schemas.PasswordRequest do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "password_requests" do
    field :used, :boolean
    field :code_hash, :string
    timestamps(type: :utc_datetime)

    belongs_to :user, NoSlice.Accounts.Schemas.User
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:used, :code_hash, :user_id])
    |> validate_required([:used, :code_hash, :user_id])
    |> validate_length(:code_hash, max: 254)
    |> foreign_key_constraint(:user_id)
  end
end
