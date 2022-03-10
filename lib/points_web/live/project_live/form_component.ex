defmodule PointsWeb.ProjectLive.FormComponent do
  @moduledoc false
  use PointsWeb, :live_component

  alias Points.Plan

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.section_header kind={:modal_h2}><%= @title %></.section_header>

      <.form
        let={f}
        for={@changeset}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save">
      
        <.input
          f={f}
          kind={:text}
          key={:title}
          label={gettext("Title")}
          placeholder={""}
          required={true} />

        <.button submit={:product_form} label={gettext("Save")} disable_with={gettext("Saving...")} />
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Plan.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Plan.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :edit_project, project_params) do
    case Plan.update_project(socket.assigns.project, project_params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Project updated successfully"))
         |> push_redirect(
           to: Routes.projects_path(socket, :index)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_project(socket, :new_project, params) do
    case Plan.create_project(params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Project created successfully"))
         |> push_redirect(
           to: Routes.projects_path(socket, :index)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
