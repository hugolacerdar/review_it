defmodule ReviewItWeb.Plugs.UUIDValidator do
  import Plug.Conn
  alias Ecto.UUID
  alias Plug.Conn
  @behaviour Plug

  # coveralls-ignore-start
  @impl true
  def init(options), do: options
  # coveralls-ignore-stop

  @impl true
  def call(%Conn{params: %{"id" => id}} = conn, _options) do
    case UUID.cast(id) do
      :error -> render_error(conn)
      {:ok, _uuid} -> conn
    end
  end

  @impl true
  def call(conn, _options), do: conn

  defp render_error(conn) do
    body = Jason.encode!(%{errors: "Invalid id format"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:bad_request, body)
    |> halt()
  end
end
