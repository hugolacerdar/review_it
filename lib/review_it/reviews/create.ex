defmodule ReviewIt.Reviews.Create do
  alias Ecto.Changeset
  alias Ecto.Multi
  alias ReviewIt.{Error, Post, Repo, Review, Technology, User}
  alias ReviewIt.Ranks.AddScore, as: AddRankScore
  alias ReviewIt.Stats.Create, as: StatCreate
  alias ReviewIt.Users.AddScore, as: AddUserScore

  def call(params) do
    changeset = Review.changeset(params)

    Multi.new()
    |> Multi.insert(:review, changeset)
    |> Multi.run(:user, &handle_user_preload/2)
    |> Multi.run(:user_score, &handle_user_score/2)
    |> Multi.run(:rank_score, &handle_rank_score/2)
    |> Multi.run(:technologies, &handle_technologies_preload/2)
    |> Multi.run(:stat, &handle_stat/2)
    |> Repo.transaction()
    |> handle_transaction()
  end

  defp handle_user_preload(repo, %{review: review}) do
    %Review{user: user} = repo.preload(review, :user)
    {:ok, user}
  end

  defp handle_technologies_preload(repo, %{review: review}) do
    %Review{post: post} = repo.preload(review, :post)
    %Post{technologies: technologies} = repo.preload(post, :technologies)

    {:ok, technologies}
  end

  defp handle_user_score(repo, %{user: user}) do
    AddUserScore.call(repo, :review, user)
  end

  defp handle_rank_score(repo, %{user: %User{id: user_id}}) do
    AddRankScore.call(repo, :review, user_id)
  end

  defp handle_stat(
         repo,
         %{technologies: technologies, user: %User{id: user_id}}
       ) do
    has_error =
      technologies
      |> Enum.map(fn %Technology{id: technology_id} ->
        StatCreate.call(repo, %{
          technology_id: technology_id,
          user_id: user_id
        })
      end)
      |> Enum.any?(fn {result, _} -> result == :error end)

    case has_error do
      true -> {:error, technologies}
      false -> {:ok, technologies}
    end
  end

  defp handle_transaction({:ok, %{review: review}}), do: {:ok, review}

  defp handle_transaction({:error, _step, %Changeset{} = changeset, _changes}) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
