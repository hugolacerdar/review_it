defmodule ReviewItWeb.UsersRankValidator do
  alias ReviewItWeb.Validator

  def validate_show(params) do
    types = %{month: :integer, year: :integer}

    Validator.validate(params, types, [])
  end
end
