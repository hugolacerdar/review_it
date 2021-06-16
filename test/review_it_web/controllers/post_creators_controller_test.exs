defmodule ReviewItWeb.PostCreatorsControllerTest do
  use ReviewItWeb.ConnCase, async: false

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "show/2" do
    setup %{conn: conn} do
      %{id: id} =
        user =
        insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      insert(:user, %{id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260", email: "reviewer@mail.com"})

      insert(:post, %{
        creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
        reviewer_id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260"
      })

      insert(:post, %{
        creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
        reviewer_id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
        title: "Please review the Business logic on Module ROTA",
        id: "8f71b12c-5fbf-4b3f-bb50-b95127c8a260"
      })

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "Returns a list of posts created by the given id's user", %{conn: conn, id: id} do
      # Arrange
      id = id
      # Act
      response =
        conn
        |> get(Routes.post_creators_path(conn, :show, id))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
                   "reviewer_id" => "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
                   "title" => "Please review the Business logic on Module XPTO"
                 },
                 %{
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
                   "reviewer_id" => "8f71b12c-5fbf-4b3f-bb50-b95127c8a260",
                   "title" => "Please review the Business logic on Module ROTA"
                 }
               ]
             } = response
    end
  end
end
