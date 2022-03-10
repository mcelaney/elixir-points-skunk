defmodule PointsWeb.ProjectLive.StoryFormComponent do
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
        id="story-form"
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

        <div class="flex flex-wrap -mx-3 mb-6">
          <div class="w-full px-3">
            <%= label f, :description, gettext("Description (Markdown)"), class: "block tracking-wide font-bold mb-2" %>
            <%= textarea f, :description, class: "appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" %>
          </div>
        </div>
        <div class="flex flex-wrap -mx-3 mb-6">
          <div class="w-full px-3 prose">
            <%= @changeset |> Ecto.Changeset.get_field(:description) |> markdown() |> raw() %>
          </div>
        </div>

        <.button submit={:product_form} label={gettext("Save")} disable_with={gettext("Saving...")} />
      </.form>
    </div>
    """
  end

  def markdown(nil), do: ""
  def markdown(body) do
    Earmark.as_html!(body)
  end

  @impl true
  def update(%{story: story} = assigns, socket) do
    changeset = Plan.change_story(story)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"story" => story_params}, socket) do
    changeset =
      socket.assigns.story
      |> Plan.change_story(story_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"story" => story_params}, socket) do
    save_story(socket, socket.assigns.action, story_params)
  end

  defp save_story(socket, :edit_story, story_params) do
    case Plan.update_story(socket.assigns.story, story_params) do
      {:ok, story} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Story updated successfully"))
         |> push_redirect(
           to: socket.assigns.return_to
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_story(socket, :new_story, params) do
    case Plan.create_story(params, socket.assigns.sub_project) do
      {:ok, story} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Story created successfully"))
         |> push_redirect(
           to: socket.assigns.return_to
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
