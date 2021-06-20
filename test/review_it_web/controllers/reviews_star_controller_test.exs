defmodule ReviewItWeb.ReviewsStarControllerTest do
  use ReviewItWeb.ConnCase

  import ReviewIt.Factory

  alias ReviewIt.Review
  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      insert(:user_expert)

      user =
        insert(
          :user,
          %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "create@mail.com"}
        )

      insert(:technology)
      post = insert(:post)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, post: post}
    end

    test "When the review exists, star the review", %{conn: conn} do
      # Arrange
      %Review{id: review_id} = insert(:review)

      # Act
      response =
        conn
        |> post(Routes.reviews_star_path(conn, :create, review_id))
        |> text_response(:no_content)

      # Assert
      assert "" == response
    end

    test "When the review not exist, returns an error", %{conn: conn} do
      # Arrange
      review_id = "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70"

      # Act
      response =
        conn
        |> post(Routes.reviews_star_path(conn, :create, review_id))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "Review not found"}
      assert expected_response == response
    end

    test "When the user is not the post creator, returns an error", %{conn: conn} do
      # Arrange
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      %Review{id: review_id} = insert(:review)

      # Act
      response =
        conn
        |> post(Routes.reviews_star_path(conn, :create, review_id))
        |> json_response(:forbidden)

      # Assert
      expected_response = %{"error" => "Operation not allowed"}
      assert expected_response == response
    end
  end
end
