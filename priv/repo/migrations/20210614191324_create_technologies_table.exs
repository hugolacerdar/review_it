defmodule ReviewIt.Repo.Migrations.CreateTechnologiesTable do
  use Ecto.Migration

  def change do
    create table(:technologies) do
      add :name, :string
      add :icon_url, :string

      timestamps()
    end

    create unique_index(:technologies, [:name, :icon_url])
  end
end
