defmodule ReviewIt.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]

  @cast_params [:nickname, :email, :password, :is_expert, :picture_url]
  @required_params [:nickname, :email]
  @required_params_with_password @required_params ++ [:password]

  @derive {Jason.Encoder, only: [:id, :nickname, :email, :is_expert, :picture_url, :inserted_at]}

  schema "users" do
    field :nickname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_expert, :boolean, default: false
    field :picture_url, :string

    timestamps()
  end

  def changeset(params) do
    build_changeset(%__MODULE__{}, params, @required_params_with_password)
  end

  def changeset(struct, params) do
    build_changeset(struct, params, @required_params)
  end

  defp build_changeset(struct, params, required_params) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(required_params)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Changeset{
           valid?: true,
           changes: %{password: password}
         } = changeset
       ) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end