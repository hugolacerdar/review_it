defmodule ReviewItWeb.Router do
  use ReviewItWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ReviewItWeb.Plugs.UUIDValidator
  end

  pipeline :auth do
    plug ReviewItWeb.Auth.Pipeline
  end

  pipeline :expert do
    plug ReviewItWeb.Plugs.ExpertAuthorization
  end

  scope "/api", ReviewItWeb do
    pipe_through [:api, :auth]

    post "/posts", PostsController, :create
    post "/reviews/:id/star", ReviewsStarController, :create
  end

  scope "/api", ReviewItWeb do
    pipe_through [:api, :auth, :expert]

    post "/reviews", ReviewsController, :create
  end

  scope "/api", ReviewItWeb do
    pipe_through :api

    get "/technologies", TechnologiesController, :index
    get "/posts", PostsController, :index
    get "/posts/:id", PostsController, :show
    get "/ranks", RanksController, :index
    post "/files", FilesController, :create
    post "/sessions", SessionsController, :create
    post "/users", UsersController, :create
    get "/users/:id", UsersController, :show
    get "/users/:id/rank", UsersRankController, :show
    get "/users/:id/posts", PostCreatorsController, :index
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
      live_dashboard "/dashboard", metrics: ReviewItWeb.Telemetry
    end
  end
end
