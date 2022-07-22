defmodule RkwstWeb.PageController do
  use RkwstWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
