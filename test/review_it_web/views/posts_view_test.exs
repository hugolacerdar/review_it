defmodule ReviewItWeb.PostsViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.Factory

  alias ReviewIt.Post
  alias ReviewItWeb.PostsView

  test "renders create.json" do
    # Arrange
    post = build(:post)

    # Act
    response = render(PostsView, "create.json", post: post)

    # Assert
    assert %{
             message: "Post created!",
             post: %Post{
               code_url: "www.codehub.com/12345ds2",
               creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
               description:
                 "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
               id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
               star_review_id: nil,
               title: "Please review the Business logic on Module XPTO"
             }
           } = response
  end

  test "renders post.json" do
    # Arrange
    post = build(:post)

    # Act
    response = render(PostsView, "post.json", post: post)

    # Assert
    assert %{
             post: %Post{
               code_url: "www.codehub.com/12345ds2",
               creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
               description:
                 "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
               id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
               star_review_id: nil,
               title: "Please review the Business logic on Module XPTO"
             }
           } = response
  end

  test "renders index.json" do
    # Arrange
    post_1 = build(:post)
    post_2 = build(:post)
    result = [post_1, post_2]
    # Act
    response = render(PostsView, "index.json", result: result)

    # Assert
    assert %{
             result: [
               %Post{
                 code_url: "www.codehub.com/12345ds2",
                 creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                 description:
                   "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                 id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
                 star_review_id: nil,
                 title: "Please review the Business logic on Module XPTO"
               },
               %Post{
                 code_url: "www.codehub.com/12345ds2",
                 creator_id: "f9b153f9-7bd8-4957-820f-f1d6570ec24e",
                 description:
                   "This code is for the web app XPQTA and it is supposed to bring the RPD foward.",
                 id: "a717fdb0-d334-4c4e-96d5-2ab58a0e8c70",
                 star_review_id: nil,
                 title: "Please review the Business logic on Module XPTO"
               }
             ]
           } = response
  end
end
