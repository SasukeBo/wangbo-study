defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/index", PageController, :index
    get "/index/:id", PageController, :show
    get "/show", PageController, :show
    get "/test", PageController, :test

    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    get "/images", ImageController, :index
    get "/redirect_test", PageController, :redirect_test, as: :redirect_test

    resources "/users", UserController do
      resources "/posts", PostController
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end
end
