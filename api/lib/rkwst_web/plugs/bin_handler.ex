defmodule RkwstWeb.Plugs.BinHandler do
  @behaviour Plug
  import Plug.Conn

  alias RkwstWeb.Services.BinService

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, opts) do
    case handle_host(conn) do
      nil -> RkwstWeb.Router.call(conn, opts)
      bin_endpoint ->
        IO.puts("ENDPOINT IS")
        IO.puts(bin_endpoint)
        case BinService.get_bin(bin_endpoint) do
          {:ok, bin} ->
            BinService.save_request(conn, bin)
          {:error} ->
            RkwstWeb.Router.call(conn, opts)
        end
    end
    conn
  end

  defp handle_host(conn) do
    case String.split(conn.host, ".")
         |> Enum.take(-2) do
      ["www", _] -> nil
      [bin_endpoint, _] -> bin_endpoint
      _ -> nil
    end
  end
end
