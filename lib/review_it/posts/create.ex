defmodule ReviewIt.Posts.Create do
  alias Ecto.Changeset
  alias ReviewIt.{Error, Post, Repo, Technology}

  def call(%{"technologies" => technologies} = params) do
    technologies =
      technologies
      |> Stream.uniq()
      |> Enum.map(&Repo.get(Technology, &1))

    with true <- Enum.all?(technologies),
         %Changeset{valid?: true} = changeset <- Post.changeset(params, technologies) do
      changeset
      |> Repo.insert()
      |> handle_insert()
    else
      %Changeset{valid?: false} = changeset -> {:error, Error.build_changeset_error(changeset)}
      false -> {:error, Error.build(:not_found, "Invalid technology id")}
    end
  end

  defp handle_insert({:ok, %Post{} = post}) do
    post = Repo.preload(post, [:author, :technologies, [star_review: :user], [reviews: :user]])

    {:ok, post}
  end
end
