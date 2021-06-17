defmodule ReviewItWeb.PostsView do
  use ReviewItWeb, :view
  alias ReviewIt.Post

  def render("create.json", %{post: %Post{} = post}) do
    %{
      message: "Post created!",
      post: post
    }
  end

  def render("post.json", %{post: %Post{} = post}), do: %{post: post}
  def render("index.json", %{result: result}), do: %{result: result}
end
