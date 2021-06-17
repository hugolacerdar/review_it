defmodule ReviewItWeb.FilesViewTest do
  use ReviewItWeb.ConnCase, async: true

  import Phoenix.View
  import ReviewIt.Factory

  alias ReviewIt.Imgbb.Client.Response
  alias ReviewItWeb.FilesView

  test "renders create.json" do
    # Arrange
    response = build(:upload_response)

    # Act
    response = render(FilesView, "create.json", response: response)

    # Assert
    expected_response = %{
      message: "File created!",
      response: %Response{image_url: "https://some-url.com.br"}
    }

    assert expected_response == response
  end
end
