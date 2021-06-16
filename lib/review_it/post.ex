defmodule ReviewIt.Post do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  @required_params [:title, :description, :code_url, :creator_id]
  @cast_params [:reviewer_id | @required_params]

  @derive {Jason.Encoder,
           only: [
             :id,
             :title,
             :description,
             :code_url,
             :creator_id,
             :reviewer_id,
             :inserted_at,
             :author
           ]}

  schema "posts" do
    field :title, :string
    field :description, :string
    field :code_url, :string

    belongs_to :author, User, foreign_key: :creator_id
    belongs_to :reviewer, User, foreign_key: :reviewer_id

    timestamps()
  end

  def changeset(params, struct \\ %__MODULE__{}) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 35, max: 100)
    |> validate_length(:description, min: 20, max: 320)
  end
end
