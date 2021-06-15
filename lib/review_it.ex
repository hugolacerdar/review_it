defmodule ReviewIt do
  @moduledoc """
  ReviewIt keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias ReviewIt.Users.Create, as: UserCreate
  alias ReviewIt.Users.Get, as: UserGet

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate get_user_by_email(email), to: UserGet, as: :by_email
end
