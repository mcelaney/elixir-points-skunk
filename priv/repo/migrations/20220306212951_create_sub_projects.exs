defmodule Points.Repo.Migrations.CreateSubProjects do
  use Ecto.Migration

  def change do
    create table(:sub_projects) do
      add :title, :citext
      add :status, :string
      add :position, :integer
      add :project_id, references(:projects, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:sub_projects, [:project_id])
  end
end
