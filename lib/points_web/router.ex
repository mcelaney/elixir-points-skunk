defmodule PointsWeb.Router do
  use PointsWeb, :router

  import PointsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PointsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PointsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PointsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PointsWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PointsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/auth/:provider", UserOauthController, :request
    get "/auth/:provider/callback", UserOauthController, :callback
  end

  scope "/", PointsWeb do
    pipe_through [:browser, :require_authenticated_user]
    live "/projects", ProjectsLive, :index
    live "/projects/new", ProjectsLive, :new_project
    live "/project/:project_id", ProjectLive, :show
    live "/project/:project_id/edit", ProjectLive, :edit
    live "/project/:project_id/new_story", ProjectLive, :new_story
    live "/story/:story_id", ProjectLive, :edit_story
    live "/sub_project/:sub_project_id", ProjectLive, :show, as: :sub_project
    live "/sub_project/:sub_project_id/new_story", ProjectLive, :new_story, as: :sub_project
  end

  scope "/", PointsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end
end
