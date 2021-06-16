defmodule ReviewIt.Repo.Migrations.CreateStatsTable do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :technology_id, references(:technologies, on_delete: :delete_all)
      add :reviews, :integer

      timestamps()
    end

    create unique_index(:stats, [:user_id, :technology_id])
  end
end
