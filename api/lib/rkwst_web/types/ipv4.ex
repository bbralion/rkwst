defmodule RkwstWeb.IPv4 do

  @type t :: String.t

  def autogenerate do
    Enum.map_join(1..4, ".", fn _ ->
      (256 * :rand.uniform())
      |> Float.floor()
      |> trunc()
    end)
  end

  def type,
      do: :inet

  def equal?(string1, string2) when is_binary(string1) and is_binary(string2) do
    string1 == string2
  end

  def equal?(inet1 = %Postgrex.INET{}, inet2 = %Postgrex.INET{}) do
    inet1 == inet2
  end

  def equal?(_, _) do
    false
  end

  def cast(inet = %Postgrex.INET{}),
      do: {:ok, to_string(inet)}
  def cast(string) when is_binary(string) do
    case parse_address(string) do
      {:ok, _} ->
        {:ok, string}
      _ ->
        :error
    end
  end

  def cast(_),
      do: :error

  def cast!(value) do
    {:ok, ipv4} = value
    ipv4
  end

  def load(inet = %Postgrex.INET{}),
      do: {:ok, to_string(inet)}
  def load(_),
      do: :error

  def dump(inet = %Postgrex.INET{}),
      do: {:ok, inet}
  def dump(string) when is_binary(string),
      do: parse_address(string)
  def dump(_),
      do: :error

  @spec parse_address(t) ::
          {:ok, Postgrex.INET.t}
          | :error
  defp parse_address(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> :inet.parse_ipv4strict_address()
    |> case do
         {:ok, address_tuple} ->
           {:ok, %Postgrex.INET{address: address_tuple}}
         {:error, :einval} ->
           :error
       end
  end

  def valid?(string) when is_binary(string) do
    parse_result =
      string
      |> String.to_charlist()
      |> :inet.parse_ipv4strict_address()

    match?({:ok, _}, parse_result)
  end
  def valid?(nil),
      do: false
end