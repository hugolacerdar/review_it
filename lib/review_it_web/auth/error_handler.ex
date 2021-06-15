defmodule ReviewItWeb.Auth.ErrorHandler do
  alias Guardian.Plug.ErrorHandler
  alias Plug.Conn

  @behaviour ErrorHandler

  def auth_error(conn, {error, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(error)})

    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(401, body)
  end
end
