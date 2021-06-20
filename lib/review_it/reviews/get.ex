defmodule ReviewIt.Reviews.Get do
  alias ReviewIt.{Error, Repo, Review}

  def by_id(id) do
    case Repo.get(Review, id) do
      nil -> {:error, Error.build(:not_found, "Review not found")}
      review -> {:ok, Repo.preload(review, :user)}
    end
  end
end
