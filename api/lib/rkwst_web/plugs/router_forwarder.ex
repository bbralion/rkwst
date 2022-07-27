defmodule RkwstWeb.Plugs.RouterForwarder do
  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, opts) do
    case handle_host(conn) do
      nil -> RkwstWeb.Router.call(conn, opts)
      bin_endpoint ->
        conn
        |> assign_bin(bin_endpoint)
        |> RkwstWeb.BinRouter.call(opts)
    end
  end

  defp handle_host(conn) do
    case String.split(conn.host, ".")
         |> Enum.take(-2) do
      ["www", _] -> nil
      [bin_endpoint, _] -> bin_endpoint
      _ -> nil
    end
  end

  defp assign_bin(conn, bin_endpoint) do
    assign(conn, :bin_endpoint, bin_endpoint)
  end
end
