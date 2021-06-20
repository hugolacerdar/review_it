defmodule ReviewIt.Users.Create do
  import Ecto.Changeset, only: [add_error: 3, put_assoc: 3]

  alias ReviewIt.{Error, Repo, Technology, User}

  def call(params) do
    params
    |> User.changeset()
    |> handle_expert_technologies(params)
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_expert_technologies(changeset, %{"is_expert" => true} = params) do
    params
    |> Map.get("technologies")
    |> handle_technologies(changeset)
  end

  defp handle_expert_technologies(changeset, _params), do: changeset

  defp handle_technologies([_t | _h] = technologies, changeset) do
    technologies =
      technologies
      |> Stream.uniq()
      |> Enum.map(&Repo.get(Technology, &1))

    if Enum.all?(technologies) do
      put_assoc(changeset, :technologies, technologies)
    else
      add_error(changeset, :technologies, "Technology not found")
    end
  end

  defp handle_technologies(nil, changeset) do
    add_error(
      changeset,
      :technologies,
      "When user is expert a technologies list must be provided"
    )
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, changeset}) do
    {:error, Error.build_changeset_error(changeset)}
  end
end
