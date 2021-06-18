defmodule ReviewItWeb.ReviewsViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.Factory

  alias ReviewIt.Review
  alias ReviewItWeb.ReviewsView

  test "renders create.json" do
    # Arrange
    review = build(:review)

    # Act
    response = render(ReviewsView, "create.json", review: review)

    # Assert
    assert %{
             message: "Review created!",
             review: %Review{
               description: "this is a description",
               id: _id,
               post_id: _post_id,
               strengths: "this is a strengths",
               suggestions: "this is a suggestions",
               user_id: _user_id,
               weakness: "this is a weakness"
             }
           } = response
  end
end
