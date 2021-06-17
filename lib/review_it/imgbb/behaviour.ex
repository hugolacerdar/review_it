defmodule ReviewIt.Imgbb.Behaviour do
  alias Plug.Upload
  alias ReviewIt.Error
  alias ReviewIt.Imgbb.Client.Response

  @callback upload(Upload.t()) :: {:ok, Response.t()} | {:error, Error.t()}
end
