defmodule ReviewItWeb.FallbackController do
  use ReviewItWeb, :controller

  alias ReviewIt.Error
  alias ReviewItWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
