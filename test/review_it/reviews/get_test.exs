defmodule ReviewIt.Reviews.GetTest do
  use ReviewIt.DataCase

  import ReviewIt.Factory

  alias ReviewIt.{Error, Review}
  alias ReviewIt.Reviews.Get

  describe "by_id/1" do
    setup do
      insert(:user_expert)
      user_id = "f9b153f9-7bd8-4957-820f-f1d6570ec24e"
      insert(:user, %{id: user_id, email: "creator@mail.com"})
      insert(:post)

      :ok
    end

    test "when review exists, returns the review" do
      # Arrange
      %Review{id: review_id} = insert(:review)

      # Act
      response = Get.by_id(review_id)

      # Assert
      assert {:ok,
              %Review{
                description: "this is a description",
                id: _id,
                post_id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
                strengths: "this is a strengths",
                suggestions: "this is a suggestions",
                user_id: "8fc5d8bc-75e4-47a3-b412-b8cd17f5701a",
                weakness: "this is a weakness"
              }} = response
    end

    test "when review not exists, returns an error" do
      # Arrange
      review_id = "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70"

      # Act
      response = Get.by_id(review_id)

      # Assert
      expected_response = {
        :error,
        %Error{result: "Review not found", status: :not_found}
      }

      assert expected_response == response
    end
  end
end
