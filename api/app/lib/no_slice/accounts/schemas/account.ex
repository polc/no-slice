defmodule NoSlice.Accounts.Schemas.Account do
  @moduledoc """
  The accounts schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :id}

  schema "accounts" do
    timestamps(type: :utc_datetime)
    has_many :users, NoSlice.Accounts.Schemas.User
  end

  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [])
  end
end
