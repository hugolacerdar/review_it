defmodule ReviewItWeb.RanksControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  describe "index/2" do
    setup %{conn: conn} do
      %{id: user_id} = insert(:user_expert)
      %{id: other_user_id} = insert(:user, %{is_expert: true})

      %{conn: conn, user_id: user_id, other_user_id: other_user_id}
    end

    test "when has ranks, return ordered by score", %{conn: conn, other_user_id: other_user_id} do
      # Arrange
      insert(:rank, %{score: 200})
      insert(:rank, %{user_id: other_user_id, score: 100})

      # Act
      response =
        conn
        |> get(Routes.ranks_path(conn, :index))
        |> json_response(:ok)

      # Assert
      assert %{
               "ranks" => [
                 %{
                   "id" => _,
                   "month" => _,
                   "score" => 200,
                   "user" => _,
                   "user_id" => _,
                   "year" => _
                 },
                 %{
                   "id" => _,
                   "month" => _,
                   "score" => 100,
                   "user" => _,
                   "user_id" => _,
                   "year" => _
                 }
               ]
             } = response
    end
  end
end
