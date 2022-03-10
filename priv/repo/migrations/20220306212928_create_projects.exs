defmodule Points.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :citext
      add :status, :string

      timestamps()
    end
    create index(:projects, [:title], unique: true)
  end
end
