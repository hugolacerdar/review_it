defmodule ReviewIt.Stat do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.{Technology, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @timestamps_opts [type: :utc_datetime]

  @required_params [:technology_id, :user_id]

  @derive {Jason.Encoder, only: [:id, :reviews, :technology, :technology_id, :user_id]}

  schema "stats" do
    field :reviews, :integer, default: 1

    timestamps()

    belongs_to :technology, Technology
    belongs_to :user, User
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:technology)
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :technology_id])
  end
end
