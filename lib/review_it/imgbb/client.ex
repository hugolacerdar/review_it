defmodule ReviewIt.Imgbb.Client do
  use Tesla

  alias Plug.Upload
  alias ReviewIt.Error
  alias ReviewIt.Imgbb.Behaviour
  alias ReviewIt.Imgbb.Client.Response
  alias Tesla.Env
  alias Tesla.Multipart

  @behaviour Behaviour

  @base_url "https://api.imgbb.com/1/upload"

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, key: get_access_key()

  @impl true
  def upload(
        url \\ @base_url,
        %Upload{content_type: content_type, filename: filename, path: path}
      ) do
    Multipart.new()
    |> Multipart.add_content_type_param(content_type)
    |> Multipart.add_file(path, filename: filename, name: :image)
    |> then(&post(url, &1))
    |> handle_upload_response()
  end

  defp handle_upload_response({:error, reason}) do
    {:error, Error.build(:bad_request, reason)}
  end

  defp handle_upload_response({
         :ok,
         %Env{
           status: 200,
           body: %{"data" => %{"image" => %{"url" => url}}}
         }
       }) do
    {:ok, Response.build(url)}
  end

  defp handle_upload_response({:ok, %Env{status: status}}) when status > 300 do
    {:error, Error.build(:bad_request, "Failed to upload file")}
  end

  defp get_access_key do
    :review_it
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:key)
  end
end
