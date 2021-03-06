defmodule PhoenixExampleMultiNestedFormWeb.Router do
  use PhoenixExampleMultiNestedFormWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixExampleMultiNestedFormWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/posts", PostLive.Index
    live "/posts/new", PostLive.New
    live "/posts/:id", PostLive.Show
    live "/posts/:id/edit", PostLive.Edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixExampleMultiNestedFormWeb do
  #   pipe_through :api
  # end
end
