defmodule ReviewIt.Users.AddScore do
  alias ReviewIt.{Repo, User}

  @valid_actions [:review, :star]

  def call(action, %User{} = user) when action in @valid_actions do
    call(Repo, action, user)
  end

  def call(repo, action, %User{} = user) when action in @valid_actions do
    user
    |> create_changeset(action)
    |> repo.update()
  end

  defp create_changeset(
         %User{score: score} = user,
         action
       ) do
    score = get_action_score(action) + score
    User.changeset(user, %{score: score})
  end

  defp get_action_score(action) do
    :review_it
    |> Application.fetch_env!(:score)
    |> Keyword.fetch!(action)
  end
end
