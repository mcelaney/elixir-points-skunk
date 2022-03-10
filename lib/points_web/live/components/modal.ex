defmodule PointsWeb.Components.Modal do
  @moduledoc false
  use PointsWeb, :live_component
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="overflow-y-auto fixed inset-0 z-10 pt-6 phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>
      <div class="flex justify-center items-end px-4 pt-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
          <div class="absolute inset-0 bg-gray-200 opacity-75"></div>
        </div>
        <div id="modal-content" class="inline-block overflow-hidden px-4 pt-5 pb-4 text-left align-bottom bg-white rounded-lg shadow-xl transition-all transform phx-modal-content sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6"
            role="dialog"
            aria-modal="true"
            aria-labelledby="modal-headline"
            phx-click-away={JS.dispatch("click", to: "#modal-close")}
            phx-window-keydown={JS.dispatch("click", to: "#modal-close")}
            phx-key="escape">
          <div class="inline-block float-right">
            <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close text-xl font-black #{PointsWeb.Components.navigate_button_class("slate", "yellow")}" %>
          </div>
          <%= live_component @component, @opts %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
