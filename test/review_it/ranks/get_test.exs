defmodule ReviewIt.Ranks.GetTest do
  use ReviewIt.DataCase, async: true

  import ReviewIt.Factory

  alias ReviewIt.{Error, Rank}
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

  describe "by_user_id/1" do
    setup do
      %{id: user_id} = insert(:user_expert)
      %{id: other_user_id} = insert(:user, %{is_expert: true})

      %{user_id: user_id, other_user_id: other_user_id}
    end

    test "when user has rank, return user's rank", %{other_user_id: other_user_id} do
      # Arrange
      insert(:rank, %{score: 200})
      insert(:rank, %{user_id: other_user_id, score: 100})
      params = %{"id" => other_user_id}

      # Act
      response = Get.by_user_id(params)

      # Assert
      assert {:ok, %Rank{score: 100, position: 2}} = response
    end

    test "when user not has a rank, return an error" do
      # Arrange
      params = %{"id" => "fa1ad3df-076f-4258-b606-a3afd97c76a2"}

      # Act
      response = Get.by_user_id(params)

      # Assert
      expected_response = {:error, %Error{status: :not_found, result: "Rank not found"}}
      assert expected_response == response
    end
  end
end
