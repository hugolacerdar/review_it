defmodule ReviewIt.Users.GetTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.{Error, User}
  alias ReviewIt.Users.Get

  describe "by_id/1" do
    test "When user exists, returns the user" do
      # Arrange
      %{id: id} = insert(:user)

      # Act
      response = Get.by_id(id)

      # Assert
      assert {:ok,
              %User{
                id: _id,
                nickname: "Banana",
                email: "banana@mail.com",
                is_expert: false,
                picture_url: nil
              }} = response
    end

    test "When user not exists, returns an error" do
      # Arrange
      id = "e38317b6-f234-4bfe-84df-29f650f59a06"

      # Act
      response = Get.by_id(id)

      # Assert
      expected_response = {
        :error,
        %Error{result: "User not found", status: :not_found}
      }

      assert expected_response == response
    end
  end

  describe "by_email/1" do
    test "When user exists, returns the user" do
      # Arrange
      %{email: email} = insert(:user)

      # Act
      response = Get.by_email(email)

      # Assert
      assert {:ok,
              %User{
                id: _id,
                nickname: "Banana",
                email: "banana@mail.com",
                is_expert: false,
                picture_url: nil
              }} = response
    end

    test "When user not exists, returns an error" do
      # Arrange
      email = "not_found@mail.com"

      # Act
      response = Get.by_email(email)

      # Assert
      expected_response = {
        :error,
        %Error{result: "User not found", status: :not_found}
      }

      assert expected_response == response
    end
  end
end
