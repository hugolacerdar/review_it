defmodule ReviewIt.Repo do
  use Ecto.Repo,
    otp_app: :review_it,
    adapter: Ecto.Adapters.Postgres
end
