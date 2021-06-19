defmodule ReviewItWeb.Plugs.ExpertAuthorization do
  import Plug.Conn

  alias Plug.Conn
  alias ReviewIt.User
  alias ReviewItWeb.Auth.Guardian.Plug, as: GuardianPlug

  @behaviour Plug

  # coveralls-ignore-start
  @impl true
  def init(options), do: options
  # coveralls-ignore-stop

  @impl true
  def call(%Conn{} = conn, _options) do
    case GuardianPlug.current_resource(conn) do
      %User{is_expert: true} -> conn
      _ -> render_error(conn)
    end
  end

  defp render_error(conn) do
    body = Jason.encode!(%{errors: "Operation not allowed"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:forbidden, body)
    |> halt()
  end
end
