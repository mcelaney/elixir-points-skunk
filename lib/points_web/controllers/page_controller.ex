defmodule PointsWeb.PageController do
  use PointsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
