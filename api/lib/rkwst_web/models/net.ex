defmodule RkwstWeb.Net do
  use RkwstWeb, :model

  schema "request" do
#    field :id, :string
    field :endpoint, :string
    field :deadline, :string

    has_many :requests, RkwstWeb.Request
    timestamps
  end

  @required_fields ~w(id endpoint deadline)
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
