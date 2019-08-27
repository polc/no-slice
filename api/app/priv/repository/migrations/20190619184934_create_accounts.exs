defmodule Bio.Repository.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      timestamps(type: :timestamptz)
    end

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :first_name, :string, null: false
      add :password_hash, :string, null: false
      timestamps(type: :timestamptz)

      add :account_id, references(:accounts, type: :uuid, on_delete: :delete_all)
    end

    create unique_index(:users, [:email])
  end
end
