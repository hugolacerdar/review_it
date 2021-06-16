defmodule ReviewItWeb.PostsValidator do
  alias ReviewIt.Error
  alias ReviewItWeb.Validator

  def validate_create(%{"technologies" => [_head | _tail] = technologies}) do
    Validator.check_uuid(technologies)
  end

  def validate_create(_) do
    {:error, Error.build(:bad_request, "Missing technologies list")}
  end
end
