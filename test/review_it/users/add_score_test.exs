defmodule ReviewIt.Users.AddScoreTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.User
  alias ReviewIt.Users.AddScore

  describe "call/2" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "when is a valid action, update user score", %{user: user} do
      # Arrange
      action = :review

      # Act
      response = AddScore.call(action, user)

      # Assert
      expected_score =
        :review_it
        |> Application.fetch_env!(:score)
        |> Keyword.fetch!(action)

      assert {:ok, %User{score: ^expected_score}} = response
    end

    test "when is an invalid action, raise an error", %{user: user} do
      # Arrange
      action = :invalid

      # Assert
      assert_raise FunctionClauseError, fn ->
        AddScore.call(action, user)
      end
    end
  end
end
