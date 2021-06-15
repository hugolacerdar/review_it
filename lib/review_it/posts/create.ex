defmodule ReviewIt.Posts.Create do
  alias Ecto.Changeset
  alias ReviewIt.{Error, Post, Repo, User}

  def call(params) do
    with %Changeset{valid?: true} <- Post.changeset(params),
         creator_id <- Map.get(params, "creator_id"),
         {:ok, %User{}} <-
           ReviewIt.get_user_by_id(creator_id) do
      params
      |> Post.changeset()
      |> Repo.insert()
      |> handle_insert()
    else
      {:error, _} -> {:error, Error.build_user_not_found_error()}
      %Changeset{valid?: false} = changeset -> {:error, Error.build_changeset_error(changeset)}
    end
  end

  defp handle_insert({:ok, %Post{} = post}) do
    post = Repo.preload(post, :author)

    {:ok, post}
  end

  defp handle_insert({:error, changeset}) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
