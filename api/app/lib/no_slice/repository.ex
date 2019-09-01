defmodule NoSlice.Repository do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :no_slice,
    adapter: Ecto.Adapters.Postgres
end
