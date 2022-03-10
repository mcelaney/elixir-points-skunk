defmodule Points.Repo.Migrations.CreateEstimates do
  use Ecto.Migration

  def change do
    create table(:estimates) do
      add :best_case, :integer
      add :worst_case, :integer
      add :story_id, references(:stories, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:estimates, [:story_id])
    create index(:estimates, [:user_id])
    create unique_index(:estimates, [:story_id, :user_id])
  end
end
