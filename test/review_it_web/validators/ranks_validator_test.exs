defmodule ReviewItWeb.RanksValidatorTest do
  use ReviewIt.DataCase, async: true

  alias ReviewIt.Error
  alias ReviewItWeb.RanksValidator

  describe "validate_index/1" do
    test "when has invalid params, returns an error" do
      # Arrange
      params = %{month: "month", year: "year", limit: "limit"}

      # Act
      response = RanksValidator.validate_index(params)

      # Assert
      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      expected_response = %{
        limit: ["is invalid"],
        month: ["is invalid"],
        year: ["is invalid"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
