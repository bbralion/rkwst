defmodule RkwstWeb.RequestView do
  use RkwstWeb, :view

  def render("index.json", %{requests: requests}) do
    %{data: render_many(requests, RkwstWeb.RequestView, "request.json")}
  end

  def render("show.json", %{request: request}) do
    %{data: render_one(request, RkwstWeb.RequestView, "request.json")}
  end

  def render("request.json", %{request: request}) do
    %{
      ip: request.ip,
      proto: request.proto,
      timestamp: request.timestamp,
      method: request.method,
      uri: request.uri,
      headers: request.headers,
      form: request.form,
      body: request.body
    }
  end
end