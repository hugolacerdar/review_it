defmodule ReviewItWeb.PostCreatorsController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.{FallbackController, PostsView}

  action_fallback FallbackController

  def index(conn, %{"id" => id}) do
    with {:ok, result} <- ReviewIt.get_post_by_creator_id(id) do
      conn
      |> put_status(:ok)
      |> put_view(PostsView)
      |> render("index.json", result: result)
    end
  end
end
