defmodule Points.Plan.Story do
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan
  alias Points.Plan.SubProject

  schema "stories" do
    field :description, :string
    field :position, :integer
    field :real_score, :integer
    field :title, :string

    belongs_to :sub_project, SubProject

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :description, :position, :real_score])
    |> validate_required([:title, :description, :position])
  end

  def changeset(story, attrs, %SubProject{} = sub_project) do
    story
    |> change()
    |> put_assoc(:sub_project, sub_project)
    |> put_change(:position, Plan.next_position(sub_project))
    |> changeset(attrs)
  end
end
