defmodule RkwstWeb.Services.BinService do
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}

  def create() do
    bin_params = %{
      endpoint: generate_endpoint(),
      deadline: DateTime.add(DateTime.utc_now, 3600, :seconds)
    }
    changeset = Bin.changeset(%Bin{}, bin_params)
    Repo.insert(changeset)
  end

  def update(%Bin{} = bin, deadline_extension_str) do
    max_extension = DateTime.add(bin.deadline, 1800, :second)
    case DateTime.from_iso8601(deadline_extension_str) do
      {:ok, deadline_extension, _offset} ->
        case DateTime.compare(deadline_extension, max_extension) do
          :gt -> {:error, :extending_error}
          _ -> bin
               |> Bin.changeset(%{deadline: deadline_extension})
               |> Repo.update()
        end
      {:error, _} -> {:error, :invalid_format}
    end
  end



  def get(id) do
    Repo.get(Bin, id)
  rescue
    Ecto.Query.CastError -> nil
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
    case get_by_endpoint(endpoint) do
      {:error} -> endpoint
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
        proto: Atom.to_string(conn.scheme),
        timestamp: DateTime.utc_now,
        method: conn.method,
        uri: conn.request_path,
        headers: Map.new(conn.req_headers),
        files: %{},
        form: conn.body_params,
        body: body
      }
    )
    Repo.insert(changeset)
  end

  def get_by_bin_id(bin_id) do
    Repo.all(Request, bin_id: bin_id)
  end

  def get_all() do
    Repo.all(Request)
  end

end
