defmodule ReviewIt.Posts.SearchHelper do
  import Ecto.Query
  import String, only: [downcase: 1]
  alias ReviewIt.{Post, Repo}

  def filter(%{
        :page => page,
        :size => size,
        :technologies => technologies,
        :solved => solved,
        :search_string => search_string
      }) do
    query =
      Post
      |> preload([p], [:author, :star_review, [reviews: :user]])
      |> technologies?(technologies)
      |> solved?(solved)
      |> search_string?(search_string)
      |> distinct([p], p.id)
      |> paginate(page, size)

    Repo.all(query) |> Repo.preload(:technologies)
  end

  defp technologies?(query, technologies) do
    case technologies do
      [_head | _tail] ->
        query
        |> join(:left, [p], t in assoc(p, :technologies))
        |> where([p, t], t.id in ^technologies)

      _ ->
        query
    end
  end

  defp search_string?(query, search_string) do
    search_string = downcase(search_string)

    case search_string != "" do
      true ->
        query
        |> where(
          [p, t],
          like(
            fragment("lower(?)", p.title),
            ^"%#{search_string}%"
          ) or
            like(
              fragment("lower(?)", p.description),
              ^"%#{search_string}%"
            )
        )

      false ->
        query
    end
  end

  defp solved?(query, solved) do
    case solved do
      true -> query |> where([p], not is_nil(p.star_review_id))
      false -> query |> where([p], is_nil(p.star_review_id))
      nil -> query
    end
  end

  defp paginate(query, page, size) do
    from query,
      limit: ^size,
      offset: ^((page - 1) * size)
  end
end
