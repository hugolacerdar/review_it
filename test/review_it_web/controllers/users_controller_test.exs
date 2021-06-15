defmodule ReviewItWeb.UsersControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    test "when all params are valid, returns the user", %{conn: conn} do
      # Arrange
      params = build(:user_params)

      # Act
      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "User created!",
               "user" => %{
                 "email" => "banana@mail.com",
                 "id" => _id,
                 "inserted_at" => _inserted_at,
                 "is_expert" => false,
                 "nickname" => "Banana",
                 "picture_url" => nil
               }
             } = response
    end

    test "when all params are valid, returns a valid token", %{conn: conn} do
      # Arrange
      params = build(:user_params)

      # Act
      %{"token" => token, "user" => %{"id" => id}} =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      {:ok, claims} = Guardian.decode_and_verify(token)

      # Assert
      assert claims["sub"] == id
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      # Arrange
      params = build(:user_params, %{"email" => "invalid"})

      # Act
      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"errors" => %{"email" => ["has invalid format"]}}
      assert expected_response == response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      %{id: id} = user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "When user exists, returns the user", %{conn: conn, id: id} do
      # Act
      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      # Assert
      assert %{
               "user" => %{
                 "email" => "banana@mail.com",
                 "id" => ^id,
                 "inserted_at" => _inserted_at,
                 "is_expert" => false,
                 "nickname" => "Banana",
                 "picture_url" => nil
               }
             } = response
    end

    test "When user not exists, returns an error", %{conn: conn} do
      # Arrange
      id = "e38317b6-f234-4bfe-84df-29f650f59aaa"

      # Act
      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "User not found"}

      assert expected_response == response
    end
  end
end
