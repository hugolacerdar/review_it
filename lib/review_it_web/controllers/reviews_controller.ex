defmodule ReviewItWeb.ReviewsController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.Auth.Guardian.Plug, as: GuardianPlug
  alias ReviewItWeb.FallbackController

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

  def show(conn, %{"id" => id}) do
    with {:ok, review} <- ReviewIt.get_review_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("review.json", review: review)
    end
  end
end
