defmodule PointsWeb.ProjectLive do
  use PointsWeb, :live_view
  alias Points.Plan
  alias Points.Plan.Project
  alias Points.Plan.SubProject
  alias Points.Plan.Story
  alias PointsWeb.ProjectLive.StoryTableComponent
  alias PointsWeb.ProjectLive.FormComponent
  alias PointsWeb.ProjectLive.StoryFormComponent

  @impl true
  def render(assigns) do
    ~H"""
    <.section_header kind={:h2}><%= @project.title %></.section_header>

    <%= if @live_action in [:edit_project] do %>
      <%= live_modal FormComponent,
        id: @live_action,
        title: @project.title || gettext("New Project"),
        action: @live_action,
        project: @project,
        return_to: return_url(@socket)
      %>
    <% end %>

    <%= if @live_action in [:new_story, :edit_story] do %>
      <%= live_modal StoryFormComponent,
        id: @live_action,
        title: @story.title || gettext("New Story"),
        action: @live_action,
        story: @story,
        project: @project,
        sub_project: @sub_project,
        return_to: return_url(@socket)
      %>
    <% end %>

    <div class="my-4 float-right">
      <.button navigate={"/"}><%= gettext("Clone Project") %></.button>
      <.button navigate={"/"}><%= gettext("Archive Project") %></.button>
      <.button navigate={"/"}><%= gettext("Delete Project") %></.button>
    </div>

    <.live_component
      module={StoryTableComponent}
      id={"story-table-#{@sub_project.id}"}
      stories={@stories} />    

    <div class="my-4">
      <.button navigate={"new_story"}><%= gettext("Add a Story") %></.button>
      <.button navigate={"/"}><%= gettext("Add Sub-Project") %></.button>
    </div>
    """
  end

  @impl true
  def mount(_parmas, session, socket) do
    result =
      socket
      |> assign_defaults(session)
      |> assign(:page_title, gettext("Projects"))
      |> assign(:return_url, "/")

    {:ok, result}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("new_story", _params, socket) do
    {:noreply, push_patch(socket, to: new_story_url(socket))}
  end

  def handle_event("edit_story", params, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :show, params) do
    content_socket = assign_contents(socket, params)

    content_socket
    |> assign(:page_title, content_socket.assigns.project.title)
    |> assign(:return_url, return_url(content_socket))
  end

  defp apply_action(socket, :new_story, params) do
    content_socket = assign_contents(socket, params)

    content_socket
    |> assign(:page_title, content_socket.assigns.project.title)
    |> assign(:story, %Story{})
    |> assign(:return_url, return_url(content_socket))
  end

  defp assign_contents(socket, %{"project_id" => project_id}) do
    project = Plan.get_project!(project_id)
    sub_project = Plan.get_default_sub_project!(project_id)
    stories = sub_project.id |> Plan.list_stories_for_sub_project() |> Enum.sort_by(&(&1.position))

    assign(socket, project: project, sub_project: sub_project, stories: stories)
  end

  defp new_story_url(%{assigns: %{project: %Project{id: project_id}, sub_project: %SubProject{position: 0}}} = socket) do
    Routes.project_path(socket, :new_story, project_id)
  end

  defp new_story_url(%{assigns: %{sub_project: %SubProject{id: sub_project_id}}} = socket) do
    Routes.sub_project_path(socket, :new_story, sub_project_id)
  end

  defp return_url(%{assigns: %{project: %Project{id: project_id}, sub_project: %SubProject{position: 0}}} = socket) do
    Routes.project_path(socket, :show, project_id)
  end

  defp return_url(%{assigns: %{sub_project: %SubProject{id: sub_project_id}}} = socket) do
    Routes.sub_project_path(socket, :show, sub_project_id)
  end

end
