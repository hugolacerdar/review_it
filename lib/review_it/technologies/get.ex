defmodule ReviewIt.Technologies.Get do
  import Ecto.Query

  alias ReviewIt.{Repo, Technology}

  def all do
    query = from t in Technology, order_by: t.name

    result = Repo.all(query)

    {:ok, result}
  end
end
