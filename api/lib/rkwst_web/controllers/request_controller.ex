defmodule RkwstWeb.RequestController do
  use RkwstWeb, :controller

  alias RkwstWeb.Models.Request

  plug :scrub_params, "request" when action in [:create, :update]

  def index(conn, _params) do
    requests = Repo.all(Request)
    render(conn, "index.json", requests: requests)
  end

  def create(conn, %{"request" => request_params, "id" => bin_id}) do
    changeset = Request.changeset(%Request{}, Map.put(request_params, "bin_id", bin_id))
    case Repo.insert(changeset) do
      {:ok, request} ->
        conn
        |> put_status(:created)
        |> render("show.json", request: request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RkwstWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Repo.get!(Request, id)
    render(conn, "show.json", request: request)
  end
end
