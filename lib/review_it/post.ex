defmodule ReviewIt.Post do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.{Review, Technology, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  @required_params [:title, :description, :code_url, :creator_id]
  @cast_params [:star_review_id | @required_params]

  @derive {Jason.Encoder,
           only: [
             :id,
             :title,
             :description,
             :code_url,
             :creator_id,
             :star_review_id,
             :inserted_at,
             :author,
             :technologies,
             :star_review,
             :reviews
           ]}

  schema "posts" do
    field(:title, :string)
    field(:description, :string)
    field(:code_url, :string)

    belongs_to(:author, User, foreign_key: :creator_id)
    belongs_to(:star_review, Review, foreign_key: :star_review_id)

    has_many(:reviews, Review)

    many_to_many(:technologies, Technology, join_through: "posts_technologies")

    timestamps()
  end

  def changeset(params, technologies, struct \\ %__MODULE__{}) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(@required_params)
    |> validate_length(:title, min: 10, max: 100)
    |> validate_length(:description, min: 20, max: 320)
    |> assoc_constraint(:author)
    |> assoc_constraint(:star_review)
    |> put_assoc(:technologies, technologies)
  end
end
