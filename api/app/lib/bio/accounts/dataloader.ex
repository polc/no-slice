defmodule Bio.Accounts.Dataloader do
  import Ecto.Query, only: [from: 2]

  alias Bio.Repository
  alias Bio.Accounts.Schemas.Account
  alias Bio.Accounts.Schemas.User

  @doc """
  Find one account using his ID.
  """
  def find_account(id) do
    Repository.get(Account, id)
  end

  def find_user(id) do
    Repository.get(User, id)
  end

  def find_user_by_email(email) do
    Repository.get_by(User, email: email)
  end

  def data() do
    Dataloader.Ecto.new(Repository, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
