defmodule ReviewItWeb.PostReviewersController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.{FallbackController, PostsView}

  action_fallback FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, result} <- ReviewIt.get_post_by_reviewer_id(id) do
      conn
      |> put_status(:ok)
      |> put_view(PostsView)
      |> render("show_all.json", result: result)
    end
  end
end
