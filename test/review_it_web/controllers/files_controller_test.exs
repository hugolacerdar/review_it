defmodule ReviewItWeb.FilesControllerTest do
  use ReviewItWeb.ConnCase, async: true

  import Mox
  import ReviewIt.Factory

  alias ReviewIt.Error
  alias ReviewIt.Imgbb.ClientMock

  describe "create/2" do
    test "when there is a valid file, returns upload url", %{conn: conn} do
      # Arrange
      file = build(:image_file)
      params = %{"file" => file}

      expect(ClientMock, :upload, fn _ ->
        {:ok, build(:upload_response)}
      end)

      # Act
      response =
        conn
        |> post(Routes.files_path(conn, :create), params)
        |> json_response(:created)

      # Assert
      expected_response = %{
        "message" => "File created!",
        "response" => %{"image_url" => "https://some-url.com.br"}
      }

      assert expected_response == response
    end

    test "when file upload fails, returns an error", %{conn: conn} do
      # Arrange
      file = build(:image_file)
      params = %{"file" => file}

      expect(ClientMock, :upload, fn _ ->
        {:error, Error.build(:bad_request, "Failed to upload file")}
      end)

      # Act
      response =
        conn
        |> post(Routes.files_path(conn, :create), params)
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"error" => "Failed to upload file"}
      assert expected_response == response
    end

    test "when receives an empty body, returns an error", %{conn: conn} do
      # Arrange
      params = %{}

      # Act
      response =
        conn
        |> post(Routes.files_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      expected_response = %{"error" => "File not provided"}
      assert expected_response == response
    end
  end
end
