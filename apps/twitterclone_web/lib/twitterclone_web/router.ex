defmodule TwittercloneWeb.Router do
  use TwittercloneWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwittercloneWeb.LayoutView, :root}
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
    get "/login/sub", SessionController, :login_sub
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout


    resources "/users", UserController
    get "/twats/:id", TwatController, :show
    get "/profile/:user_id", ProfileController, :profile
    get "/follower/:id", FollowerController, :show
    get "/following/:user_id", FollowerController, :following
    get "/followers/:user_id", FollowerController, :followers

    get "/", PageController, :index
    get "/test", PageController, :test
    get "/unauthorized", PageController, :unauthorized
    get "/error/:errorcode/:error", PageController, :error


    live "/live", LiveController
    get "/auth/google/callback/", GoogleAuthController, :index
    live "/live/username_picker", LiveUsernamePicker
  end


  scope "/", TwittercloneWeb do
    pipe_through [:browser, :auth,  :allowed_for_users]
    get "/welcome", PageController, :welcome

    get "/profile", ProfileController, :myprofile
    get "/feed", ProfileController, :feed
    get "/twat", ProfileController, :newtwat
    post "/twat", ProfileController, :createtwat
    get "/profile/update_picture_url", ProfileController, :update_picture_url



    get "/twats/:id/edit", TwatController, :edit
    patch "/twats/:id", TwatController, :update
    delete "/twats/:id", TwatController, :delete


    post "/comment/:twat_id", ProfileController, :createcomment

    get "/gen_api_key", APIController, :generate

    post "/follow/:user_id/:follower_id", ProfileController, :follow
    post "/unfollow/:user_id/:follower_id", ProfileController, :unfollow

    get "/room/new", RoomController, :new
    post "/room/create", RoomController, :create

    live "/live/room/new", LiveCreateRoom
    live "/rooms/:room_id", LiveRoom
    live "/search", LiveSearch


  end

  scope "/", TwittercloneWeb do
    pipe_through [:browser, :auth,  :allowed_for_admins]
    get "/twats", TwatController, :index

    live_dashboard "/dashboard", metrics: TwittercloneWeb.Telemetry

  end

  scope "/api", TwittercloneWeb do
    pipe_through [:api]
    resources "/users", UserAPIController, except: [:update, :delete]
    get "/twats", TwatAPIController, :index
    get "/twats/:id", TwatAPIController, :show
    resources "/comments", CommentAPIController, except: [:update, :create, :delete]

    pipe_through [:api_auth]
    put "/users/:id", UserAPIController, :update
    delete "/users/:id", UserAPIController, :delete
    get "/users+/:id", UserAPIController, :adminshow

    post "/twats", TwatAPIController, :create
    delete "/twats/:id", TwatAPIController, :delete

    post "/comments", CommentAPIController, :create
    delete "/comments/:id", CommentAPIController, :delete

  end

  pipeline :auth do
    plug TwittercloneWeb.Pipeline
    plug TwittercloneWeb.Plugs.CurrentUserPlug
    plug TwittercloneWeb.Plugs.Protection
  end

  pipeline :allowed_for_users do
    plug TwittercloneWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
    plug TwittercloneWeb.Plugs.LiveRedirectPlug
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


    scope "/" do
      pipe_through :browser


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
