defmodule Bio.Repository do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :bio,
    adapter: Ecto.Adapters.Postgres
end
