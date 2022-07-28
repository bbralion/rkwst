defmodule RkwstWeb.Services.BinService do
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}

  def create() do
    now = DateTime.utc_now()
    bin_params = %{
      endpoint: generate_endpoint(),
      created: now,
      last: now,
      deadline: DateTime.add(now, 3600, :seconds),
      count: 0
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
  import Ecto.Query
  alias Ecto.Changeset
  alias Rkwst.Repo
  alias RkwstWeb.Models.{Bin, Request}
  alias RkwstWeb.Services.BinService

  def create(conn, %Bin{} = bin) do
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
    case Repo.insert(changeset) do
      {:ok, request} ->
        bin
        |> Bin.changeset(%{count: bin.count + 1, last: DateTime.utc_now})
        |> Repo.update!()
        {:ok, request}
      {:error} ->
        {:error}
    end
  end

  def get(id) do
    Repo.get(Request, id)
  rescue
    Ecto.Query.CastError -> nil
  end

  def get_all() do
    Repo.all(Request)
  end

  def get_range(%{bin_id: bin_id, left: left, right: right, limit: limit}) do
    query = from r in Request,
              where: r.timestamp > ^left and r.timestamp < ^right and r.bin_id == ^bin_id,
              order_by: [desc: r.timestamp],
              limit: ^limit
    Repo.all(query)
  end

  def get_range(%{bin_id: bin_id, left: left, limit: limit}) do
    query = from r in Request,
              where: r.timestamp > ^left and r.bin_id == ^bin_id,
              order_by: [desc: r.timestamp],
              limit: ^limit
    Repo.all(query)
  end

  def get_range(%{bin_id: bin_id, right: right, limit: limit}) do
    query = from r in Request,
                 where: r.timestamp < ^right and r.bin_id == ^bin_id,
                 order_by: [desc: r.timestamp],
                 limit: ^limit
    Repo.all(query)
  end

  def get_range(%{bin_id: bin_id, limit: limit}) do
    query = from r in Request,
                 where: r.bin_id == ^bin_id,
                 order_by: [desc: r.timestamp],
                 limit: ^limit
    Repo.all(query)
  end

  def get_range_timestamps(%{"after" => after_id, "before" => before_id}) do
    case {get(after_id), get(before_id)} do
      {%Request{} = left, %Request{} = right} ->
        %{
          left: left.timestamp,
          right: right.timestamp
        }
      _ -> nil
    end
  end

  def get_range_timestamps(%{"before" => before_id}) do
    case get(before_id) do
      %Request{} = right -> %{right: right.timestamp}
      _ -> nil
    end
  end

  def get_range_timestamps(%{"after" => after_id}) do
    case get(after_id) do
      %Request{} = left -> %{left: left.timestamp}
      _ -> nil
    end
  end

  def get_range_timestamps(%{}), do: %{}
end
