defmodule PointsWeb.SessionDefaults do
  @moduledoc """
  Provides current user functionality for use in sockets
  """
  import Phoenix.LiveView

  alias Points.Accounts
  alias Points.Accounts.User

  def assign_defaults(socket, session) do
    socket
    |> assign_new(:current_user, fn ->
      find_current_user(session)
    end)
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end
