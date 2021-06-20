defmodule ReviewIt.Repo.Migrations.CreateRanksTable do
  use Ecto.Migration

  def change do
    create table(:ranks) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :month, :integer
      add :year, :integer
      add :score, :integer, default: 0

      timestamps()
    end

    create unique_index(:ranks, [:user_id, :month, :year])
  end
end
