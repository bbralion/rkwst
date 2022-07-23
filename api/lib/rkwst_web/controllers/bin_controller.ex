defmodule RkwstWeb.BinController do
  use RkwstWeb, :controller

  alias RkwstWeb.Bin

  plug :scrub_params, "bin" when action in [:create, :update]

  def index(conn, _params) do
    bins = Repo.all(Bin)
    render(conn, "index.json", bins: bins)
  end

  def create(conn, %{"bin" => bin_params}) do
    changeset = Bin.changeset(%Bin{}, bin_params)
    case Repo.insert(changeset) do
      {:ok, bin} ->
        conn
        |> put_status(:created)
        |> render("show.json", bin: bin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RkwstWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bin = Repo.get!(Bin, id)
    render(conn, "show.json", bin: bin)
  end
end
