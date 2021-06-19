defmodule ReviewIt.Reviews.CreateTest do
  use ReviewIt.DataCase

  import ReviewIt.Factory

  alias ReviewIt.{Error, Review}
  alias ReviewIt.Reviews.Create

  describe "call/1" do
    setup do
      insert(:user_expert)
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      insert(:technology)
      insert(:post)

      :ok
    end

    test "when all params are valid, returns the review" do
      # Arrange
      params = build(:review_params)

      # Act
      response = Create.call(params)

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

    test "when an not create user id is provided, returns an error" do
      # Arrange
      not_created_user_id = "52ad8c04-38e0-42a4-b4d0-aaffbabe7e67"
      params = build(:review_params, %{"user_id" => not_created_user_id})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{user: ["does not exist"]}

      assert errors_on(changeset) == expected_response
    end

    test "when an not create post id is provided, returns an error" do
      # Arrange
      not_created_post_id = "52ad8c04-38e0-42a4-b4d0-aaffbabe7e67"
      params = build(:review_params, %{"post_id" => not_created_post_id})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{post: ["does not exist"]}

      assert errors_on(changeset) == expected_response
    end
  end
end
