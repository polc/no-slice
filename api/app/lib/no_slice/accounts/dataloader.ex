defmodule NoSlice.Accounts.Dataloader do
  @moduledoc false

  import Ecto.Query

  alias NoSlice.Accounts.Schemas.Account
  alias NoSlice.Accounts.Schemas.PasswordRequest
  alias NoSlice.Accounts.Schemas.User
  alias NoSlice.Repository

  def find_account(id) do
    Repository.get(Account, id)
  end

  def find_user(id) do
    Repository.get(User, id)
  end

  def find_user_by_email(email) do
    Repository.get_by(User, email: email)
  end

  def find_valid_password_requests(id) do
    query_valid_password_requests()
    |> where([pr], pr.id == ^id)
    |> preload([:user])
    |> Repository.one()
  end

  def count_valid_password_requests(user_id) do
    query_valid_password_requests()
    |> where([pr], pr.user_id == ^user_id)
    |> Repository.aggregate(:count, :id)
  end

  defp query_valid_password_requests do
    # a password request is valid 10 minutes (-600)
    date = DateTime.utc_now() |> DateTime.add(-60_000_000, :second)

    from pr in PasswordRequest,
      where: pr.used == false and pr.inserted_at >= ^date
  end

  def data do
    Dataloader.Ecto.new(Repository, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
