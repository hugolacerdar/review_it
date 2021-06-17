defmodule ReviewItWeb.FilesView do
  use ReviewItWeb, :view
  alias ReviewIt.Imgbb.Client.Response

  def render("create.json", %{response: %Response{} = response}) do
    %{
      message: "File created!",
      response: response
    }
  end
end
