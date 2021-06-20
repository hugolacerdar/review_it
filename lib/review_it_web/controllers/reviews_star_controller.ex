defmodule ReviewItWeb.ReviewsStarController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.Auth.Guardian.Plug, as: GuardianPlug

  action_fallback FallbackController

  def create(conn, %{"id" => id}) do
    user_id =
      conn
      |> GuardianPlug.current_claims()
      |> Map.get("sub")

    with {:ok, _result} <- ReviewIt.star_review(id, user_id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end
end
