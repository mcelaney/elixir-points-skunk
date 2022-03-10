defmodule Points.Plan do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Points.Plan.Project
  alias Points.Plan.Story
  alias Points.Plan.SubProject
  alias Points.Repo

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Project
    |> order_by(:title)
    |> preload(:sub_projects)
    |> Repo.all()
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:project, Project.changeset(%Project{}, attrs))
    |> Multi.run(:sub_project, fn _repo, %{project: project} ->
      %SubProject{}
      |> SubProject.default_changeset(%{project: project, title: project.title, status: :default, position: 0})
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> handle_create_project_result()
  end

  defp handle_create_project_result({:ok, %{project: project, sub_project: _sub_project}}), do: {:ok, project}
  defp handle_create_project_result({:error, _name, %Ecto.Changeset{} = changeset, _changes_so_far}), do: {:error, changeset}

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  @doc """
  Returns the list of stories.

  ## Examples

      iex> list_stories()
      [%Story{}, ...]

  """
  def list_stories do
    Repo.all(Story)
  end

  @doc """
  Gets a single story.

  Raises `Ecto.NoResultsError` if the Story does not exist.

  ## Examples

      iex> get_story!(123)
      %Story{}

      iex> get_story!(456)
      ** (Ecto.NoResultsError)

  """
  def get_story!(id), do: Repo.get!(Story, id)

  @doc """
  Creates a story.

  ## Examples

      iex> create_story(%{field: value})
      {:ok, %Story{}}

      iex> create_story(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_story(attrs \\ %{}, %SubProject{} = sub_project) do
    %Story{}
    |> Story.changeset(attrs, sub_project)
    |> Repo.insert()
  end

  @doc """
  Updates a story.

  ## Examples

      iex> update_story(story, %{field: new_value})
      {:ok, %Story{}}

      iex> update_story(story, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a story.

  ## Examples

      iex> delete_story(story)
      {:ok, %Story{}}

      iex> delete_story(story)
      {:error, %Ecto.Changeset{}}

  """
  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking story changes.

  ## Examples

      iex> change_story(story)
      %Ecto.Changeset{data: %Story{}}

  """
  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end

  def get_default_sub_project!(project_id) do
    SubProject
    |> where([sub], sub.project_id == ^project_id and sub.position == 0)
    |> Repo.one!()
  end

  def list_stories_for_sub_project(sub_project_id) do
    Story
    |> where([story], story.sub_project_id == ^sub_project_id)
    |> order_by(:position)
    |> Repo.all()
  end

  def next_position(%SubProject{id: sub_project_id}) do
    SubProject
    |> where([sub_project], sub_project.id == ^sub_project_id)
    |> order_by(desc: :position)
    |> select([sub_project], sub_project.position)
    |> Repo.one!()
    |> Kernel.+(1)
  end
end
