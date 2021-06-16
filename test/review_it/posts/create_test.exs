defmodule ReviewIt.Posts.CreateTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.{Error, Post}
  alias ReviewIt.Posts.Create

  describe "call/1" do
    setup do
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      insert(:user, %{id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260", email: "reviewer@mail.com"})

      :ok
    end

    test "when all params are valid, returns the post" do
      # Arrange
      params = build(:post_params)

      # Act
      response = Create.call(params)

      # Assert
      assert {
               :ok,
               %Post{
                 code_url: "www.codehub.com/12345ds2",
                 creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                 description:
                   "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
                 id: _id,
                 reviewer_id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
                 title: "Please review the Business logic on Module XPTO"
               }
             } = response
    end

    test "when there are invalid params, returns an error" do
      # Arrange
      params = build(:post_params, %{"title" => "invalid"})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{title: ["should be at least 35 character(s)"]}

      assert errors_on(changeset) == expected_response
    end

    test "when there are any invalid id, returns an error" do
      # Arrange
      params = build(:post_params, %{"creator_id" => "9c2deae6-d914-49bd-a696-dd0261afe90b"})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
