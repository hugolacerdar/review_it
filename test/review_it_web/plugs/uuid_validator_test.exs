defmodule ReviewItWeb.Plugs.UUIDValidatorTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn
  alias ReviewItWeb.Plugs.UUIDValidator

  describe "call/2" do
    test "when there is a invalid uuid, return connection with error" do
      # Arrange
      invalid_id = "invalid_token"
      conn = conn(:get, "/resource", %{id: invalid_id})

      # Act
      result = UUIDValidator.call(conn, %{})

      # Assert
      assert %Conn{
               status: 400,
               halted: true,
               resp_body: "{\"errors\":\"Invalid id format\"}"
             } = result
    end

    test "when there is a valid uuid, return valid connection" do
      # Arrange
      valid_id = "420e26f5-e95e-4e64-80c8-d6d7de6f3098"
      conn = conn(:get, "/resource", %{id: valid_id})

      # Act
      result = UUIDValidator.call(conn, %{})

      # Assert
      assert %Conn{
               status: nil,
               halted: false
             } = result
    end
  end
end
