defmodule ReviewItWeb.UsersView do
  use ReviewItWeb, :view
  alias ReviewIt.User

  def render("create.json", %{token: token, user: %User{} = user}) do
    %{
      message: "User created!",
      token: token,
      user: user
    }
  end

  def render("user.json", %{user: %User{} = user}), do: %{user: user}
end
