defmodule ReviewItWeb.PostsControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import ReviewIt.Factory

  alias ReviewItWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      insert(:technology)

      %{id: id} =
        user =
        insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "when all params are valid, returns the post", %{conn: conn} do
      # Arrange
      params = build(:post_params)

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "Post created!",
               "post" => %{
                 "code_url" => "www.codehub.com/12345ds2",
                 "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                 "description" =>
                   "This code is for the web app XPQTA and it is supposed to bring the RPD fowars",
                 "id" => _id,
                 "title" => "Please review the Business logic on Module XPTO",
                 "technologies" => [
                   %{
                     "hex_color" => "#325d87",
                     "id" => "7df1040f-3644-4142-a2d6-20c6b0c4ab90",
                     "name" => "PostgreSQL"
                   }
                 ]
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      # Arrange
      params = build(:post_params, %{"title" => "invalid"})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"errors" => %{"title" => ["should be at least 10 character(s)"]}}
      assert expected_response == response
    end

    test "when there are any invalid id, returns an error", %{conn: conn} do
      # Arrange
      params = build(:post_params, %{"technologies" => ["9c2deae6-d914-49bd-a696-dd0261afe90b"]})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "Invalid technology id"}
      assert expected_response == response
    end

    test "when there is no technologies list or it is empty, returns an error", %{conn: conn} do
      # Arrange
      params =
        build(:post_params, %{"technologies" => ["7df1040f-3644-4142-a2d6-20c6b0c4ab90", "XPTO"]})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"error" => "Invalid technologies list"}
      assert expected_response == response
    end

    test "when there is any invalid element in technologies, returns an error", %{conn: conn} do
      # Arrange
      params = build(:post_params, %{"technologies" => []})

      # Act
      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"error" => "Missing technologies list"}
      assert expected_response == response
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      %{id: sql_id} =
        sql =
        insert(:technology,
          hex_color: "#325d87",
          name: "SQL",
          id: "f16e20db-6ff8-424c-93d1-59b146abe758"
        )

      %{id: mongodb_id} =
        mongodb =
        insert(:technology,
          hex_color: "#4aa348",
          name: "MongoDB",
          id: "63cb3232-1571-4cfb-af04-6f54fb944734"
        )

      %{id: id} = user = insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e"})

      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok,
       conn: conn, id: id, mongodb_id: mongodb_id, mongodb: mongodb, sql_id: sql_id, sql: sql}
    end

    test "when an array of tecnologies is given on params map, returns the matching posts", %{
      conn: conn,
      mongodb_id: mongodb_id,
      mongodb: mongodb,
      sql: sql
    } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"technologies" => mongodb_id}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "29558bca-ff63-4dde-b8dd-175eee6e14df",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#4aa348",
                       "id" => "63cb3232-1571-4cfb-af04-6f54fb944734",
                       "name" => "MongoDB"
                     }
                   ],
                   "title" =>
                     "I need help to get the right function for the mg module, more sp..."
                 }
               ]
             } = response
    end

    test "when an array of tecnologies and a solved equals to false is given on params map, returns the matching posts",
         %{
           conn: conn,
           mongodb_id: mongodb_id,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"technologies" => mongodb_id, "solved" => false}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "29558bca-ff63-4dde-b8dd-175eee6e14df",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#4aa348",
                       "id" => "63cb3232-1571-4cfb-af04-6f54fb944734",
                       "name" => "MongoDB"
                     }
                   ],
                   "title" =>
                     "I need help to get the right function for the mg module, more sp..."
                 }
               ]
             } = response
    end

    test "when an array of tecnologies and a solved status equals to true is given on params map, returns the matching posts",
         %{
           conn: conn,
           mongodb_id: mongodb_id,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"technologies" => mongodb_id, "solved" => true}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert response == %{"result" => []}
    end

    test "when a solved equals to false is given on params map, returns the matching posts",
         %{
           conn: conn,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"solved" => false}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "29558bca-ff63-4dde-b8dd-175eee6e14df",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#4aa348",
                       "id" => "63cb3232-1571-4cfb-af04-6f54fb944734",
                       "name" => "MongoDB"
                     }
                   ],
                   "title" =>
                     "I need help to get the right function for the mg module, more sp..."
                 },
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "a603bb16-8974-4a3b-bcac-011ec3b8b19a",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#325d87",
                       "id" => "f16e20db-6ff8-424c-93d1-59b146abe758",
                       "name" => "SQL"
                     }
                   ],
                   "title" =>
                     "I need help to get the right module for the mg function, more sp..."
                 }
               ]
             } = response
    end

    test "when a solved status equals to true is given on params map, returns the matching posts",
         %{
           conn: conn,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"solved" => true}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert response == %{"result" => []}
    end

    test "when a search string is given on parameters map, returns the matching posts considering the title and description fields",
         %{
           conn: conn,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{"search_string" => "mg function"}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "a603bb16-8974-4a3b-bcac-011ec3b8b19a",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#325d87",
                       "id" => "f16e20db-6ff8-424c-93d1-59b146abe758",
                       "name" => "SQL"
                     }
                   ],
                   "title" =>
                     "I need help to get the right module for the mg function, more sp..."
                 }
               ]
             } = response
    end

    test "when an an array of tecnologies with invalid ids is given on parameters map, returns an error",
         %{
           conn: conn,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{
        "technologies" =>
          "a603bb16-8974-4a3b-bcac-011ec3b8b19a,invalid,a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      }

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:bad_request)

      # Assert
      assert response == %{"error" => "Invalid technologies list"}
    end

    test "when a empty map is given, returns posts paginated by default values",
         %{
           conn: conn,
           mongodb: mongodb,
           sql: sql
         } do
      # Arrange
      insert(:post,
        title: "I need help to get the right function for the mg module, more sp...",
        technologies: [mongodb],
        id: "29558bca-ff63-4dde-b8dd-175eee6e14df"
      )

      insert(:post,
        title: "I need help to get the right module for the mg function, more sp...",
        technologies: [sql],
        id: "a603bb16-8974-4a3b-bcac-011ec3b8b19a"
      )

      params = %{}

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :index, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "result" => [
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "29558bca-ff63-4dde-b8dd-175eee6e14df",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#4aa348",
                       "id" => "63cb3232-1571-4cfb-af04-6f54fb944734",
                       "name" => "MongoDB"
                     }
                   ],
                   "title" =>
                     "I need help to get the right function for the mg module, more sp..."
                 },
                 %{
                   "author" => %{
                     "email" => "banana@mail.com",
                     "id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                     "is_expert" => false,
                     "nickname" => "Banana",
                     "picture_url" => nil
                   },
                   "code_url" => "www.codehub.com/12345ds2",
                   "creator_id" => "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                   "description" =>
                     "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                   "id" => "a603bb16-8974-4a3b-bcac-011ec3b8b19a",
                   "star_review" => nil,
                   "star_review_id" => nil,
                   "technologies" => [
                     %{
                       "hex_color" => "#325d87",
                       "id" => "f16e20db-6ff8-424c-93d1-59b146abe758",
                       "name" => "SQL"
                     }
                   ],
                   "title" =>
                     "I need help to get the right module for the mg function, more sp..."
                 }
               ]
             } = response
    end
  end

  describe "show/2" do
    test "when post exists, returns the post", %{conn: conn} do
      # Arrange
      insert(:user, %{id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e", email: "creator@mail.com"})
      %{id: id} = insert(:post)

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :show, id))
        |> json_response(:ok)

      # Assert
      assert %{
               "post" => %{
                 "code_url" => "www.codehub.com/12345ds2",
                 "creator_id" => _creator_id,
                 "description" =>
                   "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                 "id" => _id,
                 "inserted_at" => _inserted_at,
                 "star_review_id" => nil,
                 "title" => "Please review the Business logic on Module XPTO"
               }
             } = response
    end

    test "when post not found, returns an error", %{conn: conn} do
      # Arrange
      id = "f9b153f9-7bd8-4957-820f-f1d6570ec24e"

      # Act
      response =
        conn
        |> get(Routes.posts_path(conn, :show, id))
        |> json_response(:not_found)

      # Assert
      expected_response = %{"error" => "Post not found"}
      assert expected_response == response
    end
  end
end
