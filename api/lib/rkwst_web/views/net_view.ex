defmodule RkwstWeb.NetView do
  use RkwstWeb, :view

  def render("index.json", %{nets: nets}) do
    %{data: render_many(nets, RkwstWeb.NetView, "net.json")}
  end

  def render("show.json", %{net: net}) do
    %{data: render_one(net, RkwstWeb.NetView, "net.json")}
  end

  def render("net.json", %{net: net}) do
    %{id: net.id,
      endpoint: net.endpoint,
      deadline: net.deadline}
  end
end
