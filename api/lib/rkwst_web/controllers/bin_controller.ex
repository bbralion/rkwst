defmodule RkwstWeb.BinController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Bin


  def index(conn, _params) do
    bins = Repo.all(Bin)
    render(conn, "index.json", bins: bins)
  end

  def create(conn, _params) do
    bin_params = %{
      endpoint: "rkw.st",
      deadline: DateTime.utc_now
    }
    changeset = Bin.changeset(%Bin{}, bin_params)
    case Repo.insert(changeset) do
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
    bin = Repo.get!(Bin, id)
    render(conn, "show.json", bin: bin)
  end
end
