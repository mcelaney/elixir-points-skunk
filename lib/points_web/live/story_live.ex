defmodule PointsWeb.StoryLive do
  use PointsWeb, :live_view
  alias Points.Plan
  alias Points.Plan.Project
  alias Points.Plan.SubProject
  alias Points.Plan.Story

  @impl true
  def render(assigns) do
    ~H"""

    """
  end

  @impl true
  def mount(_parmas, session, socket) do
    result =
      socket
      |> assign_defaults(session)
      |> assign(:page_title, gettext("Stories"))
    {:ok, result}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit_story, params) do
    IO.inspect("This is where I left off")
    # content_socket
    # |> assign(:page_title, content_socket.assigns.project.title)
    # |> assign(:story, %Story{})
    # |> assign(:return_url, return_url(content_socket))
  end
end
