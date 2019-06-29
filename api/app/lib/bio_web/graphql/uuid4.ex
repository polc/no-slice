defmodule BioWeb.GraphQL.UUID4 do
  use Absinthe.Schema.Notation
  alias Ecto.UUID

  scalar :uuid4, name: "UUID4" do
    serialize(&encode_uuid4/1)
    parse(&decode_uuid4/1)
  end

  @spec decode_uuid4(Absinthe.Blueprint.Input.String.t()) :: {:ok, term()} | :error
  @spec decode_uuid4(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp decode_uuid4(%Absinthe.Blueprint.Input.String{value: value}) do
    UUID.cast(value)
  end

  defp decode_uuid4(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp decode_uuid4(_) do
    :error
  end

  defp encode_uuid4(value), do: value
end
