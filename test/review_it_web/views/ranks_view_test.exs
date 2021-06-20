defmodule ReviewItWeb.RanksViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.Factory

  alias ReviewIt.Rank
  alias ReviewItWeb.RanksView

  test "renders index.json" do
    # Arrange
    rank = build(:rank)

    # Act
    response = render(RanksView, "index.json", ranks: [rank])

    # Assert
    assert %{
             ranks: [
               %Rank{
                 month: _,
                 year: _,
                 score: _,
                 user_id: _
               }
             ]
           } = response
  end

  test "renders rank.json" do
    # Arrange
    rank = build(:rank)

    # Act
    response = render(RanksView, "rank.json", rank: rank)

    # Assert
    assert %{
             rank: %Rank{
               month: _,
               year: _,
               score: _,
               user_id: _
             }
           } = response
  end
end
