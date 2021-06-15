defmodule ReviewItWeb.SessionsControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "When all params are valid, returns the user", %{conn: conn} do
      # Arrange
      params = build(:session_params)

      # Act
      response =
        conn
        |> post(Routes.sessions_path(conn, :create, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "message" => "Session created!",
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

    test "When all params are valid, returns a valid token", %{conn: conn} do
      # Arrange
      params = build(:session_params)

      # Act
      %{"token" => token, "user" => %{"id" => id}} =
        conn
        |> post(Routes.sessions_path(conn, :create, params))
        |> json_response(:ok)

      {:ok, claims} = Guardian.decode_and_verify(token)

      # Assert
      assert claims["sub"] == id
    end

    test "When receives a wrong email, returns an error", %{conn: conn} do
      # Arrange
      params = build(:session_params, %{"email" => "invalid@mail"})

      # Act
      response =
        conn
        |> post(Routes.sessions_path(conn, :create, params))
        |> json_response(:unauthorized)

      # Assert
      expected_response = %{"error" => "Please verify your credentials"}
      assert expected_response == response
    end

    test "When receives a wrong password, returns an error", %{conn: conn} do
      # Arrange
      params = build(:session_params, %{"password" => "wrong"})

      # Act
      response =
        conn
        |> post(Routes.sessions_path(conn, :create, params))
        |> json_response(:unauthorized)

      # Assert
      expected_response = %{"error" => "Please verify your credentials"}
      assert expected_response == response
    end

    test "When receives a empty body, returns an error", %{conn: conn} do
      # Arrange
      params = %{}

      # Act
      response =
        conn
        |> post(Routes.sessions_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{
        "errors" => %{
          "email" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end
end
