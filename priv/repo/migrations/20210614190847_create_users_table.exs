defmodule ReviewIt.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      add :email, :string
      add :password_hash, :string
      add :is_expert, :boolean
      add :picture_url, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
