defmodule ReviewIt.Technology do
  use Ecto.Schema

  import Ecto.Changeset

  alias ReviewIt.{Post, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]

  @required_params [:name, :hex_color]

  @derive {Jason.Encoder, only: [:name, :hex_color]}

  schema "technologies" do
    field :name, :string
    field :hex_color, :string

    many_to_many(:posts, Post, join_through: "posts_technologies")
    many_to_many(:users, User, join_through: "users_technologies")

    timestamps()
  end

  def changeset(params, struct \\ %__MODULE__{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(
      :hex_color,
      ~r/^#(?:[0-9a-fA-F]{3}){1,2}$/,
      message: "Invalid format: not a hex color"
    )
    |> unique_constraint(:name)
    |> unique_constraint(:hex_color)
  end
end
