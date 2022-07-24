defmodule RkwstWeb.Router do
  use RkwstWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RkwstWeb do
    pipe_through :api
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

    scope "/api", RkwstWeb, as: :api do
      pipe_through :api

      scope "/v1", as: :v1 do
        get "/bins", BinController, :index
        get "/bins/:id", BinController, :show
        put "/bins/:id", BinController, :update
        post "/bins", BinController, :create

        get "/requests", RequestController, :index # for debug
        get "/bins/:id/requests", RequestController, :show
        post "/bins/:id/requests", RequestController, :create # for debug
      end
    end

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RkwstWeb.Telemetry
    end
  end
end
