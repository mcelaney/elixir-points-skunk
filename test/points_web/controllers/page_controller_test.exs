defmodule PointsWeb.PageControllerTest do
  use PointsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Points!"
  end
end
