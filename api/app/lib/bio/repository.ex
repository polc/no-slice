defmodule Bio.Repository do
  use Ecto.Repo,
    otp_app: :bio,
    adapter: Ecto.Adapters.Postgres
end
