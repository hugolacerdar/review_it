defmodule ReviewItWeb.RanksController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.RanksValidator

  action_fallback FallbackController

  def index(conn, params) do
    with {:ok, _changes} <- RanksValidator.validate_index(params) do
      ranks = ReviewIt.get_ranks_by_period(params)

      conn
      |> put_status(:ok)
      |> render("index.json", ranks: ranks)
    end
  end
end
