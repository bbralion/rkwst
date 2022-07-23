defmodule RkwstWeb.NetController do
  use RkwstWeb, :controller

  alias RkwstWeb.Net

  plug :scrub_params, "net" when action in [:create, :update]

  def index(conn, _params) do
    nets = [%{id: "n_id1", endpoint: "n_end1", deadline: "n_dead1"}]
    render(conn, "index.json", nets: nets)
  end

  def show(conn, %{"id" => id}) do
    net = %{id: "n_id1", endpoint: "n_end1", deadline: "n_dead1"}
    render(conn, "show.json", net: net)
  end
end
