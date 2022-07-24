defmodule RkwstWeb.Bin do
  use RkwstWeb, :model

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "bins" do
    field :endpoint, :string
    field :deadline, :string

    has_many :requests, RkwstWeb.Request
    timestamps
  end

  @required_fields ~w(endpoint deadline)a
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
