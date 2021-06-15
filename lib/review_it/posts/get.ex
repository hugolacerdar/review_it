defmodule ReviewIt.Posts.Get do
  import Ecto.Query
  alias ReviewIt.{Post, Repo}

  def by_creator_id(id) do
    query = from(p in Post, where: p.creator_id == ^id)

    result =
      query
      |> Repo.all()
      |> Repo.preload(:author)

    {:ok, result}
  end

  def by_reviewer_id(id) do
    query = from(p in Post, where: p.reviewer_id == ^id)

    result =
      query
      |> Repo.all()
      |> Repo.preload(:author)

    {:ok, result}
  end
end
