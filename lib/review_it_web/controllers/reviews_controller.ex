defmodule ReviewItWeb.ReviewsController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.Auth.Guardian.Plug, as: GuardianPlug

  action_fallback FallbackController

  def create(conn, params) do
    user_id =
      conn
      |> GuardianPlug.current_claims()
      |> Map.get("sub")

    params = Map.put(params, "user_id", user_id)

    with {:ok, review} <- ReviewIt.create_review(params) do
      conn
      |> put_status(:created)
      |> render("create.json", review: review)
    end
  end
end