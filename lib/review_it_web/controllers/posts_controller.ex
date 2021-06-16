defmodule ReviewItWeb.PostsController do
  use ReviewItWeb, :controller

  alias ReviewIt.Post
  alias ReviewItWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Post{} = post} <- ReviewIt.create_post(params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end
end
