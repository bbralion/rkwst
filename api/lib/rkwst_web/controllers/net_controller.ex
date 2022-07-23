defmodule RkwstWeb.NetController do
  use RkwstWeb, :controller

  alias RkwstWeb.Net

  plug :scrub_params, "net" when action in [:create, :update]

  def index(conn, _params) do
    nets = Repo.all(Net)
    render(conn, "index.json", nets: nets)
  end

  def create(conn, %{"net" => net_params}) do
    changeset = Net.changeset(%Net{}, net_params)
    case Repo.insert(changeset) do
      {:ok, net} ->
        conn
        |> put_status(:created)
        |> render("show.json", net: net)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RkwstWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    net = Repo.get!(Net, id)
    render(conn, "show.json", net: net)
  end
end
