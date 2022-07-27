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
    case get_timestamps(params) do
      nil -> conn
             |> put_status(:unprocessable_entity)
             |> render("422.json", [])
      timestamps ->
        args = timestamps |> Map.put(:limit, Map.get(params, "limit", 10)) |> Map.put(:bin_id, id)
        conn
        |> render("index.json", requests: RequestService.get_range(args))
    end
  end

  defp get_timestamps(%{"after" => after_id, "before" => before_id}) do
    case {RequestService.get(after_id), RequestService.get(before_id)} do
      {%Request{} = left, %Request{} = right} ->
        %{
          left: left.timestamp,
          right: right.timestamp
        }
      _ -> nil
    end
  end

  defp get_timestamps(%{"before" => before_id}) do
    case RequestService.get(before_id) do
      %Request{} = right ->
        %{
          right: right.timestamp
        }
      _ -> nil
    end
  end

  defp get_timestamps(%{"after" => after_id}) do
    case RequestService.get(after_id) do
      %Request{} = left ->
        %{
          left: left.timestamp
        }
      _ -> nil
    end
  end

  defp get_timestamps(%{}) do
    %{}
  end
end
