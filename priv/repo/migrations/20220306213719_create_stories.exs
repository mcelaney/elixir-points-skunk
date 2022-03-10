defmodule Points.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :title, :citext
      add :description, :text
      add :position, :integer
      add :real_score, :integer
      add :sub_project_id, references(:sub_projects, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:stories, [:sub_project_id])
  end
end
