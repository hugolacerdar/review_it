defmodule ReviewIt.Posts.CreateTest do
  use ReviewIt.DataCase, async: false

  import ReviewIt.Factory

  alias ReviewIt.{Error, Post, Technology, User}
  alias ReviewIt.Posts.Create

  describe "call/1" do
    setup do
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      insert(:technology)
      :ok
    end

    test "when all params are valid, returns the post" do
      # Arrange
      params = build(:post_params)

      # Act
      response = Create.call(params)

      # Assert
      assert {:ok,
              %Post{
                author: %User{
                  email: "creator@mail.com",
                  id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                  is_expert: false,
                  nickname: "Banana"
                },
                code_url: "www.codehub.com/12345ds2",
                creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                description:
                  "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
                id: _id,
                technologies: [
                  %Technology{
                    hex_color: "#325d87",
                    id: "7df1040f-3644-4142-a2d6-20c6b0c4ab90",
                    name: "PostgreSQL"
                  }
                ],
                title: "Please review the Business logic on Module XPTO"
              }} = response
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
      params = build(:post_params, %{"technologies" => ["9c2deae6-d914-49bd-a696-dd0261afe90b"]})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{result: "Invalid technology id", status: :not_found}} = response
    end
  end
end
