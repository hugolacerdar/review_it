defmodule ReviewIt.Review do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.{Post, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @timestamps_opts [type: :utc_datetime]

  @required_params [
    :description,
    :suggestions,
    :strengths,
    :weakness,
    :post_id,
    :user_id
  ]

  @derive {Jason.Encoder,
           only: [
             :id,
             :description,
             :suggestions,
             :strengths,
             :weakness,
             :post_id,
             :user_id,
             :user,
             :inserted_at
           ]}

  schema "reviews" do
    field :description, :string
    field :suggestions, :string
    field :strengths, :string
    field :weakness, :string

    belongs_to :post, Post
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :post_id])
  end
end
