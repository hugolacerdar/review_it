defmodule ReviewIt.Reviews.Create do
  alias Ecto.Changeset
  alias Ecto.Multi
  alias ReviewIt.{Error, Repo, Review}
  alias ReviewIt.Users.AddScore

  def call(params) do
    changeset = Review.changeset(params)

    Multi.new()
    |> Multi.insert(:review, changeset)
    |> Multi.run(:score, &handle_score/2)
    |> Repo.transaction()
    |> handle_transaction()
  end

  defp handle_score(repo, %{review: review}) do
    %Review{user: user} = Repo.preload(review, :user)
    AddScore.call(repo, :review, user)
  end

  defp handle_transaction({:ok, %{review: review}}), do: {:ok, review}

  defp handle_transaction({:error, _step, %Changeset{} = changeset, _changes}) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
