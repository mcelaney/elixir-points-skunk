defmodule PointsWeb.PageController do
  use PointsWeb, :controller

  def index(%{assigns: %{current_user: nil}} = conn, _params) do
    render(conn, "index.html")
  end

  def index(conn, _params) do
    redirect(conn, to: Routes.projects_path(conn, :index))
  end
end
