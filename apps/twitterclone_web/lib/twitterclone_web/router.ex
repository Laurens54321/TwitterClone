defmodule TwittercloneWeb.Router do
  use TwittercloneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwittercloneWeb.LayoutView, :navbar}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
    plug TwittercloneWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug TwittercloneWeb.Plugs.ApiKeyAuthorizationPlug
  end

  scope "/", TwittercloneWeb do
    pipe_through [:browser, :auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout


    resources "/users", UserController
    get "/twats/:id", TwatController, :show
    get "/profile/:user_id", ProfileController, :profile
    get "/following/:user_id", FollowerController, :following
    get "/followers/:user_id", FollowerController, :followers

    get "/", PageController, :index
    get "/unauthorized", PageController, :unauthorized
  end

  scope "/", TwittercloneWeb do
    pipe_through [:browser, :auth,  :allowed_for_users]

    get "/profile", ProfileController, :myprofile
    get "/twat", ProfileController, :newtwat
    post "/twat", ProfileController, :createtwat
    post "/comment/:twat_id", ProfileController, :createcomment
    get "/feed", ProfileController, :feed
    get "/gen_api_key", APIController, :generate

    post "/follow/:user_id/:follower_id", FollowerController, :follow
    post "/unfollow/:user_id/:follower_id", FollowerController, :unfollow
    resources "/follower", FollowerController

  end

  scope "/", TwittercloneWeb do
    pipe_through [:browser, :auth,  :allowed_for_admins]



    resources "/twats", TwatController, except: [:show, :new, :edit]

  end

  scope "/api", TwittercloneWeb do
    pipe_through [:api]
    resources "/users", UserAPIController, except: [:update]
    resources "/comments", CommentAPIController, except: [:update, :create]

    pipe_through [:api_auth]
    post "/users/update/:id", UserAPIController, :update
    get "/users+/:id", UserAPIController, :adminshow

  end

  scope "/api/admin", TwittercloneWeb do

  end

  pipeline :auth do
    plug TwittercloneWeb.Pipeline
    plug TwittercloneWeb.Plugs.CurrentUserPlug
    plug TwittercloneWeb.Plugs.Protection
  end

  pipeline :allowed_for_users do
    plug TwittercloneWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
  end

  pipeline :allowed_for_managers do
    plug TwittercloneWeb.Plugs.AuthorizationPlug, ["Admin", "Manager"]
  end

  pipeline :allowed_for_admins do
    plug TwittercloneWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

    # modified AuthorizationPlug to make this unnecesary
  # pipeline :ensure_auth do
  #   plug Guardian.Plug.EnsureAuthenticated
  # end

  # Other scopes may use custom stacks.
  # scope "/api", TwittercloneWeb do
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

      live_dashboard "/dashboard", metrics: TwittercloneWeb.Telemetry
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
end
