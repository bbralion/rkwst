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

  def show(conn, %{"id" => id}) do
    case BinService.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(RkwstWeb.ErrorView)
        |> render("404.json", [])
      %Bin{} = bin ->
        conn
        |> render("show.json", bin: bin)
    end
  end
end
