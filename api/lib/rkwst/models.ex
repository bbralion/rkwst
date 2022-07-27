defmodule RkwstWeb.Models.Bin do
  use RkwstWeb, :model

  alias RkwstWeb.Models
  alias Ecto.UUID

  @primary_key {:id, UUID, autogenerate: true}
  schema "bins" do
    field :endpoint, :string
    field :deadline, :utc_datetime

    has_many :requests, Models.Request
  end

  @required_fields ~w(endpoint deadline)a
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

defmodule RkwstWeb.Models.Request do
  use RkwstWeb, :model

  alias RkwstWeb.Models
  alias Ecto.{Enum, UUID}

  @primary_key {:id, UUID, autogenerate: true}
  schema "requests" do
    field :ip, :string
    field :proto, :string
    field :timestamp, :utc_datetime
    field :method, :string
    field :uri, :string
    field :headers, :map
    field :form, :map
    field :files, :map
    field :body, :string

    belongs_to :bin, Models.Bin, type: UUID
  end

  @required_fields ~w(ip proto timestamp method uri bin_id)a
  @optional_fields ~w(headers form files body)a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:bin_id)
  end
end
