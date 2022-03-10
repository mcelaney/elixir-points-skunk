defmodule PointsWeb.ProjectLive.StoryTableComponent do
  @moduledoc false
  use PointsWeb, :live_component

  alias Points.Plan

  @impl true
  def render(%{stories: []} = assigns) do
    ~H"""
    <div>
      <%= gettext("You don't have any stories yet. ") %>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <table class="table-fixed text-sm divide-y">
      <thead>
        <tr class="divide-x">
          <th class="p-2 text-center w-20 border-bottom"><.button navigate={"/"}><%= gettext("Delete") %></.button></th>
          <th class="p-2 text-left w-96">Story Title</th>
          <th class="p-2 text-center w-16">Best</th>
          <th class="p-2 text-center w-16">Worst</th>
          <th class="p-2 w-36"></th>
        </tr>
      </thead>
      <tbody>
        <%= for story <- @stories do %>
          <tr>
            <td class="p-2 text-center">X</td>
            <td class="p-2"><%= story.title %></td>
            <td class="p-2 text-center" colspan={2}>+ Add</td>
            <td class="p-2 text-right"><span><%= live_patch gettext("Edit"), to: Routes.story_show_path(@socket, :edit, story), class: "button" %></span> | Clone | Delete</td>
          </tr>
        <% end %>
      </tbody>
      <tfoot>
        <tr>
          <td></td>
          <th class="p-2 text-right">Total Estimates</th>
          <td class="p-2 text-center">-</td>
          <td class="p-2 text-center">-</td>
          <td></td>
        </tr>
      </tfoot>
    </table>
    """
  end
end
