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

  def render("user.json", %{user: %User{} = user}) do
    %{
      user: %{
        id: user.id,
        nickname: user.nickname,
        email: user.email,
        is_expert: user.is_expert,
        picture_url: user.picture_url,
        github_url: user.github_url,
        linkedin_url: user.linkedin_url,
        score: user.score,
        inserted_at: user.inserted_at,
        stats: user.stats,
        posts_amount: user.posts_amount
      }
    }
  end
end
