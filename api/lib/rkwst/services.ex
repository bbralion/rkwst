defmodule RkwstWeb.Services.BinService do
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}

  def create() do
    bin_params = %{
      endpoint: generate_endpoint(),
      deadline: DateTime.utc_now
    }
    changeset = Bin.changeset(%Bin{}, bin_params)
    Repo.insert(changeset)
  end

  def get(id) do
    Repo.get(Bin, id)
  end

  def get_all() do
    Repo.all(Bin)
  end

  def get_by_endpoint(endpoint) do
    case Repo.get_by(Bin, endpoint: endpoint) do
      nil -> {:error}
      %Bin{} = bin -> {:ok, bin}
    end
  end

  defp generate_endpoint() do
    endpoint = generate_random_string()
      case Repo.get_by(Bin, endpoint: endpoint) do
      nil -> endpoint
      _ -> generate_endpoint()
    end
  end

  defp generate_random_string() do
    set = Enum.to_list(?a..?z) ++
          Enum.to_list(?0..?9)
    for _ <- 1..15, into: "", do: <<Enum.random(set)>>
  end
end

defmodule RkwstWeb.Services.RequestService do
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}

  def create(conn, bin) do
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

  def get(id) do
    Repo.get(Request, id)
  end

  def get_all() do
    Repo.all(Request)
  end

end
