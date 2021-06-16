defmodule ReviewIt.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :code_url, :string, null: false
      add :creator_id, references(:users, on_delete: :delete_all)
      add :reviewer_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
