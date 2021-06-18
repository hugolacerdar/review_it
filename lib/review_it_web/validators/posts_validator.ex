defmodule ReviewItWeb.PostsValidator do
  alias ReviewIt.Error
  alias ReviewItWeb.Validator

  def validate_create(%{"technologies" => [_head | _tail] = technologies}) do
    Validator.check_uuid(technologies)
  end

  def validate_create(_) do
    {:error, Error.build(:bad_request, "Missing technologies list")}
  end

  def validate_index(params) do
    types = %{
      page: :integer,
      size: :integer,
      solved: :boolean,
      search_string: :string,
      technologies: {:array, :string}
    }

    with {:ok, changes} <- Validator.validate(params, types, []),
         technologies <-
           Map.get(params, "technologies", ["80769920-c141-4f6b-9dfa-33f4fe214155"]),
         {:ok, _} <- Validator.check_uuid(technologies) do
      {:ok, changes}
    else
      {:error, _} = error -> error
    end
  end
end
