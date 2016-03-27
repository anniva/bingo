defmodule Bingo.Router do
  use Bingo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bingo do
    pipe_through :browser # Use the default browser stack

    resources "/", GameController

    get ":id/caller", GameController, :caller
  end

  # Other scopes may use custom stacks.
  # scope "/api", Bingo do
  #   pipe_through :api
  # end
end
