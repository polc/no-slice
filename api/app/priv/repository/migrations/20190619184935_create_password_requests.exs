defmodule Bio.Repository.Migrations.CreatePasswordRequests do
  use Ecto.Migration

  def change do
    create table(:password_requests, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :used, :boolean, null: false
      add :code_hash, :string, null: false
      timestamps(type: :timestamptz)

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
    end
  end
end
