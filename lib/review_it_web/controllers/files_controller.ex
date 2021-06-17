defmodule ReviewItWeb.FilesController do
  use ReviewItWeb, :controller

  alias ReviewItWeb.FallbackController
  alias ReviewItWeb.FilesValidator

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %{"file" => file}} <- FilesValidator.validate_create(params),
         {:ok, response} <- get_upload_client().upload(file) do
      conn
      |> put_status(:created)
      |> render("create.json", response: response)
    end
  end

  def get_upload_client do
    :review_it
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:client)
  end
end
