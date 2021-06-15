defmodule ReviewIt.Users.Create do
  alias ReviewIt.{Error, Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, changeset}) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
