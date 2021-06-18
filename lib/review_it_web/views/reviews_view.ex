defmodule ReviewItWeb.ReviewsView do
  use ReviewItWeb, :view

  alias ReviewIt.Review

  def render("create.json", %{review: %Review{} = review}) do
    %{
      message: "Review created!",
      review: review
    }
  end
end
