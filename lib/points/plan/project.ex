defmodule Points.Plan.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan.SubProject

  @statuses [:active, :archived]

  schema "projects" do
    field :status, Ecto.Enum, values: @statuses, default: :active
    field :title, :string

    has_many :sub_projects, SubProject

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title])
    |> validate_required([:title, :status])
  end
end
