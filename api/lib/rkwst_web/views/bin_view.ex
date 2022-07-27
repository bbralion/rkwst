defmodule RkwstWeb.BinView do
  use RkwstWeb, :view

  def render("400.json", _assigns) do
    %{errors: %{detail: "Payload or parameters are inconsistent"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "There is no bin with given id"}}
  end

  def render("409.json", _assigns) do
    %{errors: %{detail: "Cannot extend the deadline further than 30 minutes from now"}}
  end

  def render("index.json", %{bins: bins}) do
    %{data: render_many(bins, RkwstWeb.BinView, "bin.json")}
  end

  def render("show.json", %{bin: bin}) do
    %{data: render_one(bin, RkwstWeb.BinView, "bin.json")}
  end
  def render("show.json", %{id: id}) do
    id
  end

  def render("bin.json", %{bin: bin}) do
    %{
      id: bin.id,
      endpoint: bin.endpoint,
      deadline: bin.deadline
    }
  end
end
