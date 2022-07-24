defmodule RkwstWeb.Bin do
  use RkwstWeb, :model

  alias Ecto.UUID

  @primary_key {:id, UUID, autogenerate: true}
  schema "bins" do
    field :endpoint, :string
    field :deadline, :utc_datetime

    has_many :requests, RkwstWeb.Request
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
    |> validate_required(@required_fields)
  end
end
