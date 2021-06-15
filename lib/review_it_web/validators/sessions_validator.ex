defmodule ReviewItWeb.SessionsValidator do
  alias ReviewItWeb.Validator

  def validate_create(params) do
    types = %{email: :string, password: :string}
    required = Map.keys(types)

    Validator.validate(params, types, required)
  end
end
