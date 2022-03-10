defmodule Points.Plan.SubProject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan.Project
  alias Points.Plan.Story

  @statuses [:sub, :default]

  schema "sub_projects" do
    field :position, :integer
    field :status, Ecto.Enum, values: @statuses, default: :sub
    field :title, :string
    
    belongs_to :project, Project
    has_many :stories, Story

    timestamps()
  end

  @doc false
  def changeset(sub_project, attrs) do
    sub_project
    |> cast(attrs, [:title, :status, :position])
    |> validate_required([:title, :status, :position])
  end

  def default_changeset(sub_project, attrs) do
    sub_project
    |> cast(attrs, [:title])
    |> put_change(:status, :default)
    |> put_change(:position, 0)
    |> put_assoc(:project, attrs[:project])
    |> validate_required([:title, :status, :position])
  end
end
