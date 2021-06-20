defmodule ReviewItWeb.UsersRankController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.RanksView
  alias ReviewItWeb.UsersRankValidator

  action_fallback FallbackController

  def show(conn, %{"id" => _id} = params) do
    with {:ok, _} <- UsersRankValidator.validate_show(params),
         {:ok, rank} <- ReviewIt.get_ranks_by_user_id(params) do
      conn
      |> put_status(:ok)
      |> put_view(RanksView)
      |> render("rank.json", %{rank: rank})
    end
  end
end
