defmodule NoSlice.Accounts.UseCases.ChangePassword do
  @moduledoc """
  Change a user password using a password request.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi

  alias NoSlice.Accounts.Schemas.PasswordRequest
  alias NoSlice.Accounts.Schemas.User

  @primary_key false
  embedded_schema do
    field :id, :string
    field :code, :string
    field :new_password, :string
  end

  def call(input) do
    Multi.new()
    |> Multi.run(:changeset, fn _, _ ->
      case changeset(input) do
        %Ecto.Changeset{valid?: true} = changeset -> {:ok, changeset}
        %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
      end
    end)
    |> Multi.run(:password_request, &create_password_request(&1, &2, input.id))
    |> Multi.run(:validate_code, &validate_code(&1, &2, input.code))
    |> Multi.run(:update_password, &update_password(&1, &2, input.new_password))
    |> Multi.run(:update_password_request, &update_password_request(&1, &2))
  end

  defp create_password_request(_, %{changeset: changeset}, id) do
    case Ecto.UUID.cast(id) do
      {:ok, uuid} ->
        case NoSlice.Accounts.Dataloader.find_valid_password_requests(uuid) do
          nil -> {:error, add_error(changeset, :code, "Invalid code.")}
          password_request -> {:ok, password_request}
        end

      :error ->
        {:error, add_error(changeset, :id, "Invalid ID.")}
    end
  end

  defp validate_code(_, %{changeset: changeset, password_request: password_request}, code) do
    case Bcrypt.verify_pass(code, password_request.code_hash) do
      true -> {:ok, nil}
      false -> {:error, add_error(changeset, :code, "Invalid code.")}
    end
  end

  defp update_password(repo, %{password_request: password_request}, new_password) do
    repo.update(
      User.changeset(password_request.user, %{
        password_hash: Bcrypt.hash_pwd_salt(new_password)
      })
    )
  end

  defp update_password_request(repo, %{password_request: password_request}) do
    repo.update(
      PasswordRequest.changeset(password_request, %{
        used: true
      })
    )
  end

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id, :code, :new_password])
    |> validate_required([:id, :code, :new_password])
  end
end
