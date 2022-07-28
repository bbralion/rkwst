defmodule RkwstWeb.RequestController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Request
  alias RkwstWeb.Services.{RequestService, BinService}

  plug :scrub_params, "request" when action in [:create, :update]

  def index(conn, _params) do
    render(conn, "index.json", requests: RequestService.get_all())
  end

  def show(conn, %{"id" => id} = params) do
    case BinService.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.json", [])
      _ -> show_impl(conn, params)
    end
  end

  defp show_impl(conn, %{"id" => id} = params) do
    case RequestService.get_range_timestamps(params) do
      nil -> conn
             |> put_status(:unprocessable_entity)
             |> render("422.json", [])
      timestamps ->
        args = timestamps |> Map.put(:limit, Map.get(params, "limit", 10)) |> Map.put(:bin_id, id)
        conn
        |> render("index.json", requests: RequestService.get_range(args))
    end
  end
end
