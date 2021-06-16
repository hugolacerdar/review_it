defmodule ReviewIt.Repo.Migrations.CreatePostsTechnologiesTable do
  use Ecto.Migration

  def change do
    create table(:posts_technologies, primary_key: false) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :technology_id, references(:technologies, on_delete: :delete_all)
    end

    create unique_index(:posts_technologies, [:post_id, :technology_id])
  end
end
