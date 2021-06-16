defmodule ReviewItWeb.FilesValidator do
  alias ReviewIt.Error

  def validate_create(params) do
    case Map.get(params, "file") do
      nil -> {:error, Error.build(:bad_request, "File not provided")}
      _ -> {:ok, params}
    end
  end
end
