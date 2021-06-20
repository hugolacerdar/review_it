defmodule ReviewItWeb.RanksView do
  use ReviewItWeb, :view

  def render("index.json", %{ranks: ranks}), do: %{ranks: ranks}
  def render("rank.json", %{rank: rank}), do: %{rank: rank}
end
