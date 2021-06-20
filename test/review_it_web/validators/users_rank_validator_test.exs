defmodule ReviewItWeb.UsersRankValidatorTest do
  use ReviewIt.DataCase, async: true

  alias ReviewIt.Error
  alias ReviewItWeb.UsersRankValidator

  describe "validate_show/1" do
    test "when has invalid params, returns an error" do
      # Arrange
      params = %{month: "month", year: "year"}

      # Act
      response = UsersRankValidator.validate_show(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{
        month: ["is invalid"],
        year: ["is invalid"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
