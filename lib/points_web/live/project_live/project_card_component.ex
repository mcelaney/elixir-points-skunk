defmodule PointsWeb.ProjectLive.ProjectCardComponent do
  @moduledoc false
  use PointsWeb, :live_component

  alias Points.Plan

  @impl true
  def render(assigns) do
    ~H"""
    <div class="border border-yellow-400 flex p-6">
      <.section_header kind={:h3}><%= live_redirect @project.title, to: Routes.project_path(@socket, :show, @project.id) %></.section_header>
      <ul>
        <%= for sub_project <- subs(@project) do %>
          <li><%= sub_project.title %></li>
        <% end %>
      </ul>
    </div>
    """
  end

  # Ordered by position value and don't return the default sub_project
  defp subs(%{sub_projects: []}), do: []
  defp subs(%{sub_projects: sub_projects}) do
    [default|tail] = Enum.sort_by(sub_projects, &(&1.position))
    tail
  end
end