defmodule ReviewIt.Ranks.GetTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.Rank
  alias ReviewIt.Ranks.Get

  describe "by_period/1" do
    setup do
      %{id: user_id} = insert(:user_expert)
      %{id: other_user_id} = insert(:user, %{is_expert: true})

      %{user_id: user_id, other_user_id: other_user_id}
    end

    test "when has ranks, return ordered by score", %{other_user_id: other_user_id} do
      # Arrange
      insert(:rank, %{score: 200})
      insert(:rank, %{user_id: other_user_id, score: 100})

      # Act
      response = Get.by_period()

      # Assert
      assert [%Rank{score: 200, position: 1}, %Rank{score: 100, position: 2}] = response
    end
  end
end
