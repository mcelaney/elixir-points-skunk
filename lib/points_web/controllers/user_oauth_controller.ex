defmodule PointsWeb.UserOauthController do
  use PointsWeb, :controller
  alias Points.Accounts
  alias PointsWeb.UserAuth

  plug Ueberauth

  @rand_pass_length 15

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, %{"provider" => "github"}) do
    user_params = %{email: user_info.email, password: random_password()}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        UserAuth.log_in_user(conn, user)
      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
