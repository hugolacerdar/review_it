defmodule ReviewItWeb.Plugs.ExpertAuthorizationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import ReviewIt.Factory

  alias Plug.Conn
  alias ReviewItWeb.Plugs.ExpertAuthorization

  describe "call/2" do
    test "when there is an expert user, returns the connection" do
      # Arrange
      conn =
        :get
        |> conn("/resource", %{})
        |> put_private(:guardian_default_resource, build(:user_expert))

      # Act
      result = ExpertAuthorization.call(conn, %{})

      # Assert
      assert %Conn{
               status: nil,
               halted: false
             } = result
    end

    test "when there is an invalid user, returns connection with error" do
      # Arrange
      conn =
        :get
        |> conn("/resource", %{})
        |> put_private(:guardian_default_resource, build(:user))

      # Act
      result = ExpertAuthorization.call(conn, %{})

      # Assert
      assert %Conn{
               status: 403,
               halted: true,
               resp_body: "{\"errors\":\"Operation not allowed\"}"
             } = result
    end
  end
end
