defmodule ReviewItWeb.RanksValidator do
  alias ReviewItWeb.Validator

  def validate_index(params) do
    types = %{month: :integer, year: :integer, limit: :integer}

    Validator.validate(params, types, [])
  end
end
