defmodule ReviewItWeb.PostsControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      %{id: id} =
        user =
        insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      insert(:user, %{id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260", email: "reviewer@mail.com"})

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "when all params are valid, returns the post", %{conn: conn} do
      # Arrange
      params = build(:post_params)

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "Post created!",
               "post" => %{
                 "code_url" => "www.codehub.com/12345ds2",
                 "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                 "description" =>
                   "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
                 "id" => _id,
                 "reviewer_id" => "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
                 "title" => "Please review the Business logic on Module XPTO"
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      # Arrange
      params = build(:post_params, %{"title" => "invalid"})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"errors" => %{"title" => ["should be at least 35 character(s)"]}}
      assert expected_response == response
    end

    test "when there are any invalid id, returns an error", %{conn: conn} do
      # Arrange
      params = build(:post_params, %{"creator_id" => "9c2deae6-d914-49bd-a696-dd0261afe90b"})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "User not found"}
      assert expected_response == response
    end
  end
end
