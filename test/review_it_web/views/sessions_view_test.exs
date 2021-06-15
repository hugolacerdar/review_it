defmodule ReviewItWeb.SessionsViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.{Factory}

  alias ReviewIt.User
  alias ReviewItWeb.SessionsView

  test "renders create.json" do
    # Arrange
    user = build(:user)
    token = "handle_token"

    # Act
    response = render(SessionsView, "create.json", user: user, token: token)

    # Assert
    assert %{
             message: "Session created!",
             token: ^token,
             user: %User{
               email: "banana@mail.com",
               id: _id,
               is_expert: false,
               nickname: "Banana",
               picture_url: nil
             }
           } = response
  end
end
