defmodule ReviewItWeb.FilesValidatorTest do
  use ReviewIt.DataCase, async: true

  alias ReviewIt.Error
  alias ReviewItWeb.FilesValidator

  describe "validate_create/1" do
    test "when has missing params, returns an error" do
      # Arrange
      params = %{}

      # Act
      response = FilesValidator.validate_create(params)

      # Assert
      expected_response = {
        :error,
        %Error{result: "File not provided", status: :bad_request}
      }

      assert expected_response == response
    end

    test "when all params are valid, returns the params" do
      # Arrange
      params = %{"file" => "any file"}

      # Act
      response = FilesValidator.validate_create(params)

      # Assert
      expected_response = {:ok, params}

      assert expected_response == response
    end
  end
end
