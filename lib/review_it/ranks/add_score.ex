defmodule ReviewIt.Ranks.AddScore do
  alias ReviewIt.{Repo, Rank}

  @valid_actions [:review, :star]

  def call(action, user_id) when action in @valid_actions do
    call(Repo, action, user_id)
  end

  def call(repo, action, user_id) when action in @valid_actions do
    %{month: month, year: year} = DateTime.utc_now()

    points = get_action_points(action)

    case repo.get_by(Rank, user_id: user_id, month: month, year: year) do
      nil ->
        create_user_rank(repo, %{
          user_id: user_id,
          month: month,
          year: year,
          score: points
        })

      rank ->
        update_user_rank(repo, rank, points)
    end
  end

  defp create_user_rank(repo, params) do
    params
    |> Rank.changeset()
    |> repo.insert()
  end

  defp update_user_rank(repo, %Rank{score: score} = rank, points) do
    rank
    |> Rank.changeset(%{score: score + points})
    |> repo.update()
  end

  defp get_action_points(action) do
    :review_it
    |> Application.fetch_env!(:score)
    |> Keyword.fetch!(action)
  end
end
