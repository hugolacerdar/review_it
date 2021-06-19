defmodule ReviewIt.Stats.Create do
  alias ReviewIt.{Repo, Stat}

  def call(params), do: call(Repo, params)

  def call(repo, params) do
    params
    |> Stat.changeset()
    |> repo.insert(
      conflict_target: [:user_id, :technology_id],
      on_conflict: [inc: [reviews: 1]]
    )
  end
end
