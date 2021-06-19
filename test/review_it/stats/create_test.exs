defmodule ReviewIt.Stats.CreateTest do
  use ReviewIt.DataCase, async: false

  import ReviewIt.Factory

  alias ReviewIt.Stats.Create
  alias ReviewIt.{Technology, Repo, Stat, User}

  describe "call/1" do
    setup do
      %Technology{id: technology_id} = insert(:technology)
      %User{id: user_id} = insert(:user_expert)

      %{technology_id: technology_id, user_id: user_id}
    end

    test "when all params are valid, create the stat", %{
      technology_id: technology_id,
      user_id: user_id
    } do
      # Arrange
      params = %{technology_id: technology_id, user_id: user_id}

      # Act
      response = Create.call(params)

      # Assert
      assert {:ok,
              %Stat{
                reviews: 1,
                technology_id: ^technology_id,
                user_id: ^user_id
              }} = response
    end

    test "when already has a stat, increase reviews value", %{
      technology_id: technology_id,
      user_id: user_id
    } do
      # Arrange
      %Stat{id: id, reviews: reviews} = insert(:stat)
      params = %{technology_id: technology_id, user_id: user_id}

      # Act
      Create.call(params)

      # Assert
      %Stat{reviews: response} = Repo.get!(Stat, id)
      expected_response = reviews + 1

      assert expected_response == response
    end
  end
end
