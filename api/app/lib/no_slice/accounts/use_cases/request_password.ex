defmodule NoSlice.Accounts.UseCases.RequestPassword do
  @moduledoc """
  Create a new password request and send a email containing a validation code.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi

  alias NoSlice.Accounts.Schemas.PasswordRequest

  embedded_schema do
    field :email, :string
  end

  def call(input) do
    Multi.new()
    |> Multi.run(:changeset, fn _, _ ->
      case changeset(input) do
        %Ecto.Changeset{valid?: true} = changeset -> {:ok, changeset}
        %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
      end
    end)
    |> Multi.run(:user, fn _, %{changeset: changeset} ->
      case NoSlice.Accounts.Dataloader.find_user_by_email(input.email) do
        nil -> {:error, add_error(changeset, :email, "Unable to find user.")}
        user -> {:ok, user}
      end
    end)
    |> Multi.run(:validation, fn _, %{changeset: changeset, user: user} ->
      case NoSlice.Accounts.Dataloader.count_valid_password_requests(user.id) do
        n when n < 3 ->
          {:ok, nil}

        _ ->
          {:error, add_error(changeset, :email, "Too many password requests already exist.")}
      end
    end)
    |> Multi.run(:password_request, fn repo, %{user: user} ->
      code = ExCrypto.rand_chars(12)

      changeset =
        PasswordRequest.changeset(%PasswordRequest{
          used: false,
          code_hash: Bcrypt.hash_pwd_salt(code),
          user_id: user.id
        })

      case repo.insert(changeset) do
        {:ok, password_request} -> {:ok, %{code: code, id: password_request.id}}
        {:error, error} -> {:error, error}
      end
    end)
    |> Multi.run(:send_email, fn _, %{password_request: %{code: code, id: id}} ->
      {:ok, nil}
    end)
  end

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
