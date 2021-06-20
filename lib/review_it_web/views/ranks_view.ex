defmodule ReviewItWeb.RanksView do
  use ReviewItWeb, :view

  def render("index.json", %{ranks: ranks}), do: %{ranks: ranks}
end
