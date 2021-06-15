defmodule ReviewItWeb.UsersViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.{Factory}

  alias ReviewIt.User
  alias ReviewItWeb.UsersView

  test "renders create.json" do
    # Arrange
    user = build(:user)
    token = "handle_token"

    # Act
    response = render(UsersView, "create.json", user: user, token: token)

    # Assert
    assert %{
             message: "User created!",
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

  test "renders user.json" do
    # Arrange
    user = build(:user)

    # Act
    response = render(UsersView, "user.json", user: user)

    # Assert
    assert %{
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
