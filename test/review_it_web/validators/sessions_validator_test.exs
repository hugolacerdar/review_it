defmodule ReviewItWeb.SessionsValidatorTest do
  use ReviewIt.DataCase, async: true

  alias ReviewIt.Error
  alias ReviewItWeb.SessionsValidator

  describe "validate_create/1" do
    test "when has missing params, returns an error" do
      # Arrange
      params = %{}

      # Act
      response = SessionsValidator.validate_create(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{
        email: ["can't be blank"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end

    test "when all params are valid, returns changes" do
      # Arrange
      params = %{"email" => "banana@mail.com", "password" => "123"}

      # Act
      response = SessionsValidator.validate_create(params)

      # Assert
      expected_response = {:ok, %{email: "banana@mail.com", password: "123"}}

      assert expected_response == response
    end
  end
end
