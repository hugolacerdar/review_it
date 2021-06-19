defmodule ReviewIt.Rank do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @timestamps_opts [type: :utc_datetime]

  @required_params [:user_id, :month, :year, :score]

  @derive {Jason.Encoder, only: [:id, :user_id, :month, :year, :score, :user]}

  schema "ranks" do
    field :month, :integer
    field :year, :integer
    field :score, :integer, default: 0

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :month, :year])
  end
end
