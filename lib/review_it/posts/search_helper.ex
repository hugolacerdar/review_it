defmodule ReviewIt.Posts.SearchHelper do
  import Ecto.Query
  alias ReviewIt.{Post, Repo}

  def filter(%{:page => page, :size => size, :technologies => technologies, :solved => false}) do
    query =
      from(p in Post,
        where: is_nil(p.star_review_id),
        join: t in assoc(p, :technologies),
        where: t.id in ^technologies,
        order_by: [desc: p.inserted_at]
      )
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  def filter(%{:page => page, :size => size, :technologies => technologies, :solved => true}) do
    query =
      from(p in Post,
        where: not is_nil(p.star_review_id),
        join: t in assoc(p, :technologies),
        where: t.id in ^technologies,
        order_by: [desc: p.inserted_at]
      )
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  def filter(%{:page => page, :size => size, :technologies => technologies}) do
    query =
      from(p in Post,
        join: t in assoc(p, :technologies),
        where: t.id in ^technologies,
        order_by: [desc: p.inserted_at]
      )
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  def filter(%{:page => page, :size => size, :solved => false}) do
    query =
      from(p in Post, where: is_nil(p.star_review_id), order_by: [desc: p.inserted_at])
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  def filter(%{:page => page, :size => size, :solved => true}) do
    query =
      from(p in Post, where: not is_nil(p.star_review_id), order_by: [desc: p.inserted_at])
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  def filter(%{:page => page, :size => size}) do
    query =
      from(p in Post, order_by: [desc: p.inserted_at])
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload([:author, :technologies, :star_review])
  end

  defp paginate(query, page, size) do
    from query,
      limit: ^size,
      offset: ^((page - 1) * size)
  end
end
