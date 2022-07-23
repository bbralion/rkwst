defmodule RkwstWeb.Request do
  use RkwstWeb, :model

  schema "request" do
#    field :id, :string
    field :ip, :string
    field :proto, :string
    field :timestamp, :string
    field :method, :string
    field :uri, :string
    field :headers, :map
    field :form, :map
    field :body, :string

    belongs_to :net, RestApi.Net

    timestamps
  end

  @required_fields ~w(id ip proto timestamp method uri headers form body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
