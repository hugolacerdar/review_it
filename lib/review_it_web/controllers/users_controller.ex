defmodule ReviewItWeb.UsersController do
  use ReviewItWeb, :controller

  alias ReviewIt.User
  alias ReviewItWeb.Auth.Guardian
  alias ReviewItWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- ReviewIt.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    end
  end
end
