defmodule ReviewIt.Posts.Get do
  import Ecto.Query
  alias ReviewIt.{Post, Error, Repo}
  alias ReviewIt.Posts.SearchHelper

  @default_params %{
    :page => 1,
    :size => 10,
    :technologies => nil,
    :solved => nil,
    :search_string => ""
  }
  def all(params) do
    params = Map.merge(@default_params, params)

    result = SearchHelper.filter(params)

    {:ok, result}
  end

  def by_creator_id(id) do
    query = from(p in Post, where: p.creator_id == ^id)

    result =
      query
      |> Repo.all()
      |> Repo.preload([:author, :technologies, :star_review, :reviews])

    {:ok, result}
  end

  def by_id(id) do
    case Repo.get(Post, id) do
      nil -> {:error, Error.build(:not_found, "Post not found")}
      post -> {:ok, Repo.preload(post, [:author, :technologies, :star_review, :reviews])}
    end
  end
end
