defmodule ReviewIt.Users.CreateTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.{Error, User}
  alias ReviewIt.Users.Create

  describe "call/1" do
    test "when all params are valid, returns the user" do
      # Arrange
      params = build(:user_params)

      # Act
      response = Create.call(params)

      # Assert
      assert {:ok,
              %User{
                id: _id,
                nickname: "Banana",
                email: "banana@mail.com",
                is_expert: false,
                picture_url: nil,
                github_url: "https://github.com/banana",
                linkedin_url: "https://linkedin.com/in/banana",
                score: 0
              }} = response
    end

    test "when there are invalid params, returns an error" do
      # Arrange
      params =
        build(:user_params, %{
          "email" => "invalid",
          "github_url" => "invalid",
          "linkedin_url" => "invalid"
        })

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{
        email: ["has invalid format"],
        github_url: ["has invalid format"],
        linkedin_url: ["has invalid format"]
      }

      assert errors_on(changeset) == expected_response
    end

    test "when email was already registered, returns an error" do
      # Arrange
      insert(:user)
      params = build(:user_params)

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{email: ["has already been taken"]}

      assert errors_on(changeset) == expected_response
    end

    test "when create an expert, returns the user" do
      # Arrange
      %{id: tech_id} = insert(:technology)

      params =
        build(:user_params, %{
          "is_expert" => true,
          "technologies" => [tech_id]
        })

      # Act
      response = Create.call(params)

      # Assert
      assert {:ok,
              %User{
                id: _id,
                nickname: "Banana",
                email: "banana@mail.com",
                is_expert: true,
                picture_url: nil,
                github_url: "https://github.com/banana",
                linkedin_url: "https://linkedin.com/in/banana",
                score: 0
              }} = response
    end

    test "when create an expert and not found the technology, returns an error" do
      # Arrange
      tech_id = "3beb6a91-1580-455a-b377-13930f08565d"

      params =
        build(:user_params, %{
          "is_expert" => true,
          "technologies" => [tech_id]
        })

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{technologies: ["Technology not found"]}

      assert errors_on(changeset) == expected_response
    end

    test "when create an expert and not provide the technology list, returns an error" do
      # Arrange
      params = build(:user_params, %{"is_expert" => true})

      # Act
      response = Create.call(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{
        technologies: ["When user is expert a technologies list must be provided"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
