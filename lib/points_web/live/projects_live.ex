defmodule PointsWeb.ProjectsLive do
  use PointsWeb, :live_view
  alias Points.Plan
  alias Points.Plan.Project
  alias PointsWeb.ProjectLive.ProjectCardComponent

  @impl true
  def render(assigns) do
    ~H"""
    <.section_header kind={:h2}><%= gettext("Projects") %></.section_header>
    <%= if @live_action in [:new_project] do %>
      <%= live_modal PointsWeb.ProjectLive.FormComponent,
        id: @live_action,
        title: @project.title || gettext("New Project"),
        action: @live_action,
        project: @project,
        return_to: Routes.projects_path(@socket, :index)
      %>
    <% end %>

    <div class="my-4">
      <.button navigate={"new_project"}><%= gettext("Add a Project") %></.button>
      <.button navigate={"/"}><%= gettext("See Archived Projects") %></.button>
    </div>
    <div class="container mx-auto">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <%= for project <- @projects do %>
          <.live_component module={ProjectCardComponent} id={"project-#{project.id}"} project={project} />
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_parmas, session, socket) do
    result =
      socket
      |> assign_defaults(session)
      |> assign(:page_title, gettext("Projects"))

    {:ok, result}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("new_project", _, socket) do
    {:noreply, push_patch(socket, to: Routes.projects_path(socket, :new_project))}
  end

  defp apply_action(socket, :new_project, _params) do
    socket
    |> assign(:page_title, gettext("New Project"))
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Projects"))
    |> assign(:projects, Plan.list_projects())
  end
end
