defmodule ReviewItWeb.TechnologiesView do
  use ReviewItWeb, :view
  alias ReviewIt.Technology

  def render("index.json", %{technologies: [%Technology{} | _] = technologies}) do
    %{technologies: technologies}
  end
end
