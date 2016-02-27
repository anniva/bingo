defmodule Bingo.PageController do
  use Bingo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
