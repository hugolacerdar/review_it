defmodule ReviewIt.Ranks.Get do
  import Ecto.Query

  alias ReviewIt.{Error, Repo, Rank}

  @default_limit 10

  def by_period(params \\ %{}) do
    %{month: month, year: year} = DateTime.utc_now()

    month = Map.get(params, "month", month)
    year = Map.get(params, "year", year)
    limit = Map.get(params, "limit", @default_limit)

    query =
      from r in Rank,
        where: r.month == ^month and r.year == ^year,
        order_by: [desc: r.score],
        select: %{r | position: dense_rank() |> over(order_by: [desc: r.score])},
        limit: ^limit,
        preload: [:user]

    Repo.all(query)
  end

  def by_user_id(%{"id" => user_id} = params) do
    %{month: month, year: year} = DateTime.utc_now()

    month = Map.get(params, "month", month)
    year = Map.get(params, "year", year)

    ranked_query =
      from r in Rank,
        where: r.month == ^month and r.year == ^year,
        select: %{r | position: dense_rank() |> over(order_by: [desc: r.score])}

    query =
      from r in subquery(ranked_query),
        where: r.user_id == ^user_id,
        preload: [:user]

    case Repo.one(query) do
      nil -> {:error, Error.build(:not_found, "Rank not found")}
      rank -> {:ok, rank}
    end
  end
end
