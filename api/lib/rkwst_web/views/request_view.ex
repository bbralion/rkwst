defmodule RkwstWeb.RequestView do
  use RkwstWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "There is no request with given id"}}
  end

  def render("422.json", _assigns) do
    %{errors: %{detail: "Request with id specified in before doesn't exist in the bin"}}
  end

  def render("index.json", %{requests: requests}) do
    %{data: render_many(requests, RkwstWeb.RequestView, "request.json")}
  end

  def render("show.json", %{request: request}) do
    %{data: render_one(request, RkwstWeb.RequestView, "request.json")}
  end

  def render("request.json", %{request: request}) do
    %{
      id: request.id,
      ip: request.ip,
      proto: request.proto,
      timestamp: request.timestamp,
      method: request.method,
      uri: request.uri,
      headers: request.headers,
      form: request.form,
      files: request.files,
      body: request.body,
      bin_id: request.bin_id
    }
  end
end
