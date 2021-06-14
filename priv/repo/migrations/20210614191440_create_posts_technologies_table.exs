defmodule ReviewIt.Repo.Migrations.CreatePostsTechnologiesTable do
  use Ecto.Migration

  def change do
    create table(:posts_technologies) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :tech_id, references(:technologies, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:posts_technologies, [:post_id, :tech_id])
  end
end
