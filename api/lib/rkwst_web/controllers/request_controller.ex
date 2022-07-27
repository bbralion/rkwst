defmodule RkwstWeb.RequestController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Request
  alias RkwstWeb.Services.RequestService

  plug :scrub_params, "request" when action in [:create, :update]

  def index(conn, _params) do
    render(conn, "index.json", requests: RequestService.get_all())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "index.json", requests: RequestService.get_by_bin_id(id))
  end
end
