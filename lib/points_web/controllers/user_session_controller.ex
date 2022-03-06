defmodule PointsWeb.UserSessionController do
  use PointsWeb, :controller

  alias PointsWeb.UserAuth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
