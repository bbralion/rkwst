defmodule RkwstWeb.BinView do
  use RkwstWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "There is no bin with given id"}}
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
