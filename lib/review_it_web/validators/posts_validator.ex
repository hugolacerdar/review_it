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

    params = parse_tech_string(params)

    with {:ok, changes} <- Validator.validate(params, types, []),
         technologies <-
           Map.get(params, "technologies", ["80769920-c141-4f6b-9dfa-33f4fe214155"]),
         {:ok, _} <- Validator.check_uuid(technologies) do
      {:ok, changes}
    else
      {:error, _} = error -> error
    end
  end

  def parse_tech_string(params) do
    case Map.get(params, "technologies", nil) |> is_nil() do
      false -> Map.put(params, "technologies", to_list(params["technologies"]))
      true -> params
    end
  end

  def to_list(string) do
    String.split(string, ",")
  end
end
