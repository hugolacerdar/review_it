defmodule ReviewIt.Users.Get do
  import Ecto.Query

  alias ReviewIt.{Error, Repo, User}

  def by_id(id) do
    query =
      from u in User,
        where: u.id == ^id,
        preload: [stats: [:technology]],
        left_join: p in assoc(u, :posts),
        group_by: u.id,
        select: %{u | posts_amount: count(p.id)}

    case Repo.one(query) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> {:ok, user}
    end
  end

  def by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> {:ok, user}
    end
  end
end
