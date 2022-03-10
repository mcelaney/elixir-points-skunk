defmodule Points.Plan.Estimate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "estimates" do
    field :best_case, :integer
    field :worst_case, :integer
    field :story_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(estimate, attrs) do
    estimate
    |> cast(attrs, [:best_case, :worst_case])
    |> validate_required([:best_case, :worst_case])
  end
end
