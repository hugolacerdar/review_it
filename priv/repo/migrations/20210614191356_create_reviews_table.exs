defmodule ReviewIt.Repo.Migrations.CreateReviewsTable do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)
      add :description, :text
      add :suggestions, :text
      add :strengths, :text
      add :weakness, :text

      timestamps()
    end

    create unique_index(:reviews, [:user_id, :post_id])
  end
end
