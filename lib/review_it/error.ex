defmodule ReviewIt.Error do
  alias Ecto.Changeset

  @keys [:status, :result]
  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def build_changeset_error(%Changeset{} = changeset) do
    build(:bad_request, changeset)
  end
end
