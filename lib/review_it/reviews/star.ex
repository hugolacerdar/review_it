defmodule ReviewIt.Reviews.Star do
  alias Ecto.Multi
  alias ReviewIt.Ranks.AddScore, as: AddRankScore
  alias ReviewIt.Users.AddScore, as: AddUserScore
  alias ReviewIt.{Error, Post, Repo, Review, User}

  def call(id, user_id) do
    Multi.new()
    |> Multi.run(:review, &handle_review(&1, &2, id))
    |> Multi.run(:post, &handle_post/2)
    |> Multi.run(:check_permission, &handle_permission(&1, &2, user_id))
    |> Multi.run(:update_post, &handle_update_post/2)
    |> Multi.run(:reviewer, &handle_reviewer/2)
    |> Multi.run(:user_score, &handle_user_score/2)
    |> Multi.run(:rank_score, &handle_rank_score/2)
    |> Repo.transaction()
    |> handle_transaction()
  end

  defp handle_review(repo, _data, id) do
    case repo.get(Review, id) do
      nil -> {:error, Error.build(:not_found, "Review not found")}
      review -> {:ok, review}
    end
  end

  defp handle_post(repo, %{review: %Review{post_id: id}}) do
    case repo.get(Post, id) do
      nil -> {:error, Error.build(:not_found, "Review not found")}
      review -> {:ok, review}
    end
  end

  defp handle_permission(_repo, %{post: %Post{creator_id: creator_id}}, user_id) do
    case creator_id == user_id do
      false -> {:error, Error.build(:forbidden, "Operation not allowed")}
      true -> {:ok, :allowed}
    end
  end

  defp handle_update_post(
         repo,
         %{
           post: %Post{} = post,
           review: %Review{id: review_id}
         }
       ) do
    %Post{technologies: technologies} = post = repo.preload(post, [:technologies])
    changeset = Post.changeset(%{star_review_id: review_id}, technologies, post)
    repo.update(changeset)
  end

  defp handle_reviewer(repo, %{review: %Review{} = review}) do
    %Review{user: user} = repo.preload(review, [:user])
    {:ok, user}
  end

  defp handle_user_score(repo, %{reviewer: reviewer}) do
    AddUserScore.call(repo, :star, reviewer)
  end

  defp handle_rank_score(repo, %{reviewer: %User{id: user_id}}) do
    AddRankScore.call(repo, :star, user_id)
  end

  defp handle_transaction({:ok, %{update_post: update_post}}), do: {:ok, update_post}

  defp handle_transaction({:error, _step, %Error{} = error, _changes}) do
    {:error, error}
  end
end
