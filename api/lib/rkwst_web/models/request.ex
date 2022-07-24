defmodule RkwstWeb.Request do
  use RkwstWeb, :model

  alias RkwstWeb.{IPv4}
  alias Ecto.{Enum, UUID}

  @primary_key {:id, UUID, autogenerate: true}
  schema "requests" do
    field :ip, IPv4
    field :proto, Enum, values: [:http, :https]
    field :timestamp, :utc_datetime
    field :method, Enum, values: [:GET, :POST, :DELETE, :PUT, :HEAD, :OPTIONS, :PATCH, :TRACE, :CONNECT]
    field :uri, :string
    field :headers, :map
    field :form, :map
    field :files, :map
    field :body, :string

    belongs_to :bin, RkwstWeb.Bin, type: UUID
  end

  @required_fields ~w(ip proto timestamp method uri headers form files body bin_id)a
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
    |> foreign_key_constraint(:bin_id)
  end
end
