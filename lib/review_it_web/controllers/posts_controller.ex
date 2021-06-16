defmodule ReviewItWeb.PostsController do
  use ReviewItWeb, :controller

  alias ReviewIt.{Post, User}
  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.PostsValidator

  action_fallback FallbackController

  def create(conn, params) do
    %{private: %{:guardian_default_resource => %User{id: id}}} = conn
    params = Map.put(params, "creator_id", id)

    with {:ok, _result} <- PostsValidator.validate_create(params),
         {:ok, %Post{} = post} <- ReviewIt.create_post(params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end
end
