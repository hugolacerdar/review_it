defmodule ReviewItWeb.SessionsController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.Auth.Guardian
  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.SessionsValidator

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, _changes} <- SessionsValidator.validate_create(params),
         {:ok, token, user} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("create.json", token: token, user: user)
    end
  end
end
