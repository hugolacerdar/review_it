defmodule ReviewIt.Repo.Migrations.CreateTechnologiesTable do
  use Ecto.Migration

  def change do
    create table(:technologies) do
      add :name, :string
      add :hex_color, :string

      timestamps()
    end

    create unique_index(:technologies, [:name])
    create unique_index(:technologies, [:hex_color])
  end
end
