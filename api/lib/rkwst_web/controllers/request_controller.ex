defmodule RkwstWeb.RequestController do
  use RkwstWeb, :controller

  alias RkwstWeb.Request

  plug :scrub_params, "request" when action in [:create, :update]

  def index(conn, _params) do
    requests = [
      %{
        id: "r_id1",
        ip: "r_ip1",
        proto: "r_proto1",
        deadline: "r_dead1",
        timestamp: "r_ts1",
        method: "r_m1",
        uri: "r_uri1",
        headers: "r_head1",
        form: "r_form1",
        body: "r_body1"
      }
    ]
    render(conn, "index.json", requests: requests)
  end

  def show(conn, %{"id" => id}) do
    request = %{
      id: "r_id1",
      ip: "r_ip1",
      proto: "r_proto1",
      deadline: "r_dead1",
      timestamp: "r_ts1",
      method: "r_m1",
      uri: "r_uri1",
      headers: "r_head1",
      form: "r_form1",
      body: "r_body1"
    }
    render(conn, "show.json", request: request)
  end
end
