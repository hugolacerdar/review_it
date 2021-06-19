defmodule ReviewIt.Ranks.AddScoreTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.Ranks.AddScore
  alias ReviewIt.{Rank, User}

  describe "call/2" do
    setup do
      %User{id: user_id} = insert(:user_expert)
      %{user_id: user_id}
    end

    test "when is a valid action, create user rank", %{user_id: user_id} do
      # Arrange
      action = :review

      # Act
      response = AddScore.call(action, user_id)

      # Assert
      expected_score =
        :review_it
        |> Application.fetch_env!(:score)
        |> Keyword.fetch!(action)

      assert {:ok, %Rank{score: ^expected_score}} = response
    end

    test "when is an invalid action, raises an error", %{user_id: user_id} do
      # Arrange
      action = :invalid

      # Assert
      assert_raise FunctionClauseError, fn ->
        AddScore.call(action, user_id)
      end
    end

    test "when already has an rank, increases the score", %{user_id: user_id} do
      # Arrange
      %Rank{score: score} = insert(:rank)
      action = :review

      # Act
      response = AddScore.call(action, user_id)

      # Assert
      action_points =
        :review_it
        |> Application.fetch_env!(:score)
        |> Keyword.fetch!(action)

      expected_score = action_points + score

      assert {:ok, %Rank{score: ^expected_score}} = response
    end
  end
end
