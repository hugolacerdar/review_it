defmodule ReviewIt.Imgbb.ClientTest do
  use ExUnit.Case, async: true

  import ReviewIt.Factory

  alias Plug.Conn
  alias ReviewIt.Error
  alias ReviewIt.Imgbb.Client
  alias ReviewIt.Imgbb.Client.Response

  describe "upload/2" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there is a valid file, returns the upload response", %{bypass: bypass} do
      # Arrange
      params = build(:image_file)
      url = endpoint_url(bypass.port)

      # Act
      body = ~s({"data":{"image":{"url":"https://i.ibb.co/w04Prt6/c1f64245afb2.png"}}})

      Bypass.expect(bypass, "POST", "", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.upload(url, params)

      # Assert
      expected_response = {
        :ok,
        %Response{image_url: "https://i.ibb.co/w04Prt6/c1f64245afb2.png"}
      }

      assert expected_response == response
    end

    test "when uploads file fail, returns an error", %{bypass: bypass} do
      # Arrange
      params = build(:image_file)
      url = endpoint_url(bypass.port)

      # Act
      Bypass.expect(bypass, "POST", "", fn conn ->
        Conn.resp(conn, 400, "")
      end)

      response = Client.upload(url, params)

      # Assert
      expected_response = {:error, %Error{result: "Failed to upload file", status: :bad_request}}
      assert expected_response == response
    end

    test "when there is a generic error, returns an error", %{bypass: bypass} do
      # Arrange
      params = build(:image_file)
      url = endpoint_url(bypass.port)

      # Act
      Bypass.down(bypass)
      response = Client.upload(url, params)

      # Assert
      expected_response = {:error, %Error{result: :econnrefused, status: :bad_request}}
      assert expected_response == response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
