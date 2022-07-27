defmodule AuthorizationTaskWeb.Router do
  use AuthorizationTaskWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AuthorizationTask.Guardian.AuthPipeline
  end

  scope "/api", AuthorizationTaskWeb do
    pipe_through :api

    # Endpoint for registering a user
    post "/users", UserController, :register

    # Endpoint for starting a new session
    post "/session/new", SessionController, :new
  end

  scope "/api", AuthorizationTaskWeb do
    pipe_through [:api, :auth]

    # Endpoint for refreshing a session Token
    post "/session/refresh", SessionController, :refresh

    # Endpoint for deleting a Token
    post "/session/delete", SessionController, :delete
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AuthorizationTaskWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
