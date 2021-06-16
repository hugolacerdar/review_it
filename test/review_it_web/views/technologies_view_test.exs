defmodule ReviewItWeb.TechnologiesViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.Factory

  alias ReviewIt.Technology
  alias ReviewItWeb.TechnologiesView

  test "renders index.json" do
    # Arrange
    technologies = [build(:technology)]

    # Act
    response = render(TechnologiesView, "index.json", technologies: technologies)

    # Assert
    assert %{
             technologies: [
               %Technology{
                 hex_color: "#325d87",
                 id: "7df1040f-3644-4142-a2d6-20c6b0c4ab90",
                 name: "PostgreSQL"
               }
             ]
           } = response
  end
end
