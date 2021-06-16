defmodule ReviewItWeb.Validator do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias ReviewIt.Error

  def validate(params, types, required_keys) do
    {%{}, types}
    |> cast(params, required_keys)
    |> validate_required(required_keys)
    |> handle_validation()
  end

  def check_uuid(list) do
    error? =
      Enum.any?(list, fn x ->
        case Ecto.UUID.cast(x) do
          :error -> true
          _ -> false
        end
      end)

    case error? do
      false -> {:ok, list}
      true -> {:error, Error.build(:bad_request, "Invalid technologies list")}
    end
  end

  defp handle_validation(%Changeset{valid?: true} = changeset) do
    {:ok, changeset.changes}
  end

  defp handle_validation(%Changeset{valid?: false} = changeset) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
