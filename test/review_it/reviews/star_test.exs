defmodule ReviewIt.Reviews.StarTest do
  use ReviewIt.DataCase

  import ReviewIt.Factory

  alias ReviewIt.{Error, Post, Review}
  alias ReviewIt.Reviews.Star

  describe "call/1" do
    setup do
      insert(:user_expert)
      user_id = "f9b153f9-7bd8-4957-820f-f1d6570ec24e"
      insert(:user, %{id: user_id, email: "creator@mail.com"})
      insert(:technology)
      post = insert(:post)

      %{user_id: user_id, post: post}
    end

    test "When the review exists, star the review", %{user_id: user_id} do
      # Arrange
      %Review{id: review_id} = insert(:review)

      # Act
      response = Star.call(review_id, user_id)

      # Assert
      assert {:ok, %Post{star_review_id: ^review_id}} = response
    end

    test "When the review not exist, returns an error", %{user_id: user_id} do
      # Arrange
      review_id = "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70"

      # Act
      response = Star.call(review_id, user_id)

      # Assert
      expected_response = {
        :error,
        %Error{result: "Review not found", status: :not_found}
      }

      assert expected_response == response
    end

    test "When the user is not the post creator, returns an error" do
      # Arrange
      %Review{id: review_id} = insert(:review)
      user_id = "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70"

      # Act
      response = Star.call(review_id, user_id)

      # Assert
      expected_response = {
        :error,
        %Error{result: "Operation not allowed", status: :forbidden}
      }

      assert expected_response == response
    end
  end
end
