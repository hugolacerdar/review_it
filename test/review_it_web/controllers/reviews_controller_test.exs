defmodule ReviewItWeb.ReviewsControllerTest do
  use ReviewItWeb.ConnCase

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      insert(:technology)
      insert(:post)
      user = insert(:user_expert)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "When all params are valid, returns the user", %{conn: conn} do
      # Arrange
      params = build(:review_params)

      # Act
      response =
        conn
        |> post(Routes.reviews_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "Review created!",
               "review" => %{
                 "id" => _id,
                 "description" => "this is a description",
                 "inserted_at" => _inserted_at,
                 "post_id" => "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
                 "strengths" => "this is a strengths",
                 "suggestions" => "this is a suggestions",
                 "user_id" => "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a",
                 "weakness" => "this is a weakness"
               }
             } = response
    end

    test "When an not expert user made the request, returns an error", %{conn: conn} do
      # Arrange
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      params = build(:review_params)

      # Act
      response =
        conn
        |> post(Routes.reviews_path(conn, :create, params))
        |> json_response(:forbidden)

      # Assert
      expected_response = %{"errors" => "Operation not allowed"}
      assert expected_response == response
    end
  end
end
