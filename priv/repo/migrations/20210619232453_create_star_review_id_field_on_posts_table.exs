defmodule ReviewIt.Repo.Migrations.CreateStartReviewIdFieldOnPostsTable do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :star_review_id, references(:reviews, on_delete: :delete_all)
    end
  end
end
