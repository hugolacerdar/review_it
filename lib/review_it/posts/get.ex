defmodule ReviewIt.Posts.Get do
  import Ecto.Query
  alias ReviewIt.{Post, Repo}
  alias ReviewIt.Posts.SearchHelper

  def all(params) do
    page = Map.get(params, :page, 1)
    size = Map.get(params, :size, 10)

    params =
      params
      |> Map.put_new(:page, page)
      |> Map.put_new(:size, size)

    result = SearchHelper.filter(params)

    {:ok, result}
  end

  def by_creator_id(id) do
    query = from(p in Post, where: p.creator_id == ^id)

    result =
      query
      |> Repo.all()
      |> Repo.preload([:author, :technologies, :star_review])

    {:ok, result}
  end
end
