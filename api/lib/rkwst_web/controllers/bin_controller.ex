defmodule RkwstWeb.BinController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Bin
  alias RkwstWeb.Services.BinService


  def index(conn, _params) do
    render(conn, "index.json", bins: BinService.get_all())
  end

  def create(conn, _params) do
    case BinService.create() do
      {:ok, bin} ->
        conn
        |> put_status(:created)
        |> render("show.json", id: bin.id)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RkwstWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "deadline" => deadline}) do
    case BinService.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.json", [])
      %Bin{} = bin ->
        case BinService.update(bin, deadline) do
          {:ok, bin} ->
            conn
            |> render("show.json", id: bin.id)
          {:error, :extending_error} ->
            conn
            |> put_status(:conflict)
            |> render("409.json", [])
          {:error, :invalid_format} ->
            conn
            |> put_status(:bad_request)
            |> render("400.json", [])
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(RkwstWeb.ChangesetView, "error.json", changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    case BinService.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.json", [])
      %Bin{} = bin ->
        conn
        |> render("show.json", bin: bin)
    end
  end
end
