defmodule RkwstWeb.BinHandler do
  use RkwstWeb, :controller

  alias RkwstWeb.Services.{BinService, RequestService}

  def handle(conn, _params) do
    endpoint = conn.assigns.bin_endpoint
    case BinService.get_by_endpoint(endpoint) do
      {:ok, bin} ->
        case RequestService.create(conn, bin) do
          {:ok, request} ->
            conn
            |> put_status(:created)
            |> put_view(RkwstWeb.RequestView)
            |> render("show.json", request: request)
            {:error}
            conn
            |> put_status(:internal_server_error)
            |> put_view(RkwstWeb.ErrorView)
            |> render("500.json", [])
        end
      {:error} ->
        conn
        |> put_status(:not_found)
        |> put_view(RkwstWeb.BinView)
        |> render("404.json", [])
    end
  end
end
