defmodule BioWeb.GraphQL.Error do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc "An error."
  object :error do
    field :property, non_null(:string)
    field :message, non_null(:string)
  end

  def changeset_to_errors(%Ecto.Changeset{valid?: false, errors: errors}) do
    Enum.map(errors, fn {attr, {msg, props}} ->
      message =
        Enum.reduce(props, msg, fn {k, v}, acc ->
          String.replace(acc, "%{#{k}}", to_string(v))
        end)

      %{property: attr, message: message}
    end)
  end
end
