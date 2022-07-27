defmodule RkwstWeb.RequestController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Request
  alias RkwstWeb.Services.RequestService

  plug :scrub_params, "request" when action in [:create, :update]

  def index(conn, _params) do
    render(conn, "index.json", requests: RequestService.get_all())
  end

  def show(conn, %{"id" => id}) do
    case RequestService.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(RkwstWeb.RequestView)
        |> render("404.json", [])
      %Request{} = request ->
        conn
        |> render("show.json", request: request)
    end
  end
end
