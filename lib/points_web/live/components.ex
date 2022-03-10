defmodule PointsWeb.Components do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import PointsWeb.Gettext

  alias Phoenix.HTML.Form
  alias PointsWeb.Components.Modal
  alias PointsWeb.ErrorHelpers

  def button(%{navigate: _to} = assigns) do
    ~H"""
    <button phx-click={@navigate} class={navigate_button_class("slate", "yellow")} >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def button(%{submit: _to} = assigns) do
    ~H"""
    <%= Form.submit @label, phx_disable_with: gettext("Saving..."), class: navigate_button_class("slate", "yellow") %>
    """
  end

  def section_header(%{kind: :h2} = assigns) do
    ~H"""
    <h2 class="uppercase font-thin text-5xl inline"><%= render_slot(@inner_block) %></h2>
    """
  end

  def section_header(%{kind: :h3} = assigns) do
    ~H"""
    <h2 class="uppercase font-thin text-4xl"><%= render_slot(@inner_block) %></h2>
    """
  end

  def section_header(%{kind: :modal_h2} = assigns) do
    ~H"""
    <h2 class="uppercase font-thin text-2xl inline"><%= render_slot(@inner_block) %></h2>
    """
  end

  def input(%{kind: :text} = assigns) do
    ~H"""
    <div class="flex flex-wrap -mx-3 mb-6">
      <div class="w-full px-3">
        <%= Form.label @f, @key, @label, class: "block tracking-wide font-bold mb-2" %>
        <%= Form.text_input @f, @key, required: @required, placeholder: @placeholder, class: "appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" %>
        <%= ErrorHelpers.error_tag @f, @key %>
      </div>
    </div>
    """
  end

  def navigate_button_class(text_color, background_color) do
    colors = "text-#{text_color}-900 bg-#{background_color}-400"
    layout = "h-8 px-4 mr-2 pt-1 pb-1 rounded-full"
    behavior = "transition-colors duration-150 cursor-pointer focus:shadow-outline hover:underline"
    type = "text-sm"
    Enum.join([colors, layout, behavior, type], " ")
  end

  @doc """
  Renders a component inside the `TaglockrWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal PointsWeb.ProjectLive.FormComponent,
        id: @project.id || :new,
        action: @live_action,
        project: @project,
        return_to: Routes.project_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(Modal, modal_opts)
  end
end
