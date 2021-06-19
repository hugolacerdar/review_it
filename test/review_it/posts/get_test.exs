defmodule ReviewIt.Posts.GetTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.{Error, Post}
  alias ReviewIt.Posts.Get

  describe "by_id/1" do
    test "when post exists, returns the post" do
      # Arrange
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      %Post{id: id} = insert(:post)

      # Act
      response = Get.by_id(id)

      # Assert
      assert {:ok,
              %Post{
                code_url: "www.codehub.com/12345ds2",
                creator_id: _creator_id,
                description:
                  "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                id: _id,
                inserted_at: _inserted_at,
                reviews: [],
                star_review_id: nil,
                title: "Please review the Business logic on Module XPTO",
                updated_at: _updated_at
              }} = response
    end

    test "when post not found, returns an error" do
      # Arrange
      id = "f9b153f9-7bd8-4957-820f-f1d6570ec24e"

      # Act
      response = Get.by_id(id)

      # Assert
      expected_response = {:error, %Error{result: "Post not found", status: :not_found}}

      assert expected_response == response
    end
  end
end
