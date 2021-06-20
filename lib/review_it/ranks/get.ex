defmodule ReviewIt.Ranks.Get do
  import Ecto.Query

  alias ReviewIt.{Repo, Rank}

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
end
