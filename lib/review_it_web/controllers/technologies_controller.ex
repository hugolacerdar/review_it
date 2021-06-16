defmodule ReviewItWeb.TechnologiesController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _) do
    with {:ok, technologies} <- ReviewIt.get_all_technologies() do
      conn
      |> put_status(:ok)
      |> render("index.json", technologies: technologies)
    end
  end
end
