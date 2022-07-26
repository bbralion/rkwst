defmodule RkwstWeb.Services.BinService do
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}

  def get_bin(bin_endpoint) do
    case Repo.get_by(Bin, id: bin_endpoint) do
      nil -> {:error}
      %Bin{} = bin -> {:ok, bin}
    end
  end

  def save_request(conn, bin) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    changeset = Request.changeset(
      %Request{},
      %{
        ip: conn.remote_ip |> :inet.ntoa() |> to_string(),
        bin_id: bin.id,
        proto: conn.scheme,
        timestamp: DateTime.utc_now,
        method: conn.method,
        uri: conn.request_path,
        headers: Map.new(conn.req_headers),
        files: %{},
        form: %{},
        body: body
      }
    )
    Repo.insert(changeset)
  end
end
