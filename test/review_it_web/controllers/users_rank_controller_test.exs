defmodule ReviewItWeb.UsersRankControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  describe "show/2" do
    setup %{conn: conn} do
      %{id: user_id} = insert(:user_expert)
      %{id: other_user_id} = insert(:user, %{is_expert: true})

      %{conn: conn, user_id: user_id, other_user_id: other_user_id}
    end

    test "when user has rank, return user's rank", %{conn: conn, other_user_id: other_user_id} do
      # Arrange
      insert(:rank, %{score: 200})
      insert(:rank, %{user_id: other_user_id, score: 100})

      # Act
      response =
        conn
        |> get(Routes.users_rank_path(conn, :show, other_user_id))
        |> json_response(:ok)

      # Assert
      assert %{
               "rank" => %{
                 "id" => _,
                 "month" => _,
                 "position" => 2,
                 "score" => 100,
                 "user" => _,
                 "user_id" => _,
                 "year" => _
               }
             } = response
    end

    test "when user not has a rank, return an error", %{conn: conn} do
      # Arrange
      id = "fa1ad3df-076f-4258-b606-a3afd97c76a2"

      # Act
      response =
        conn
        |> get(Routes.users_rank_path(conn, :show, id))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "Rank not found"}
      assert expected_response == response
    end
  end
end
