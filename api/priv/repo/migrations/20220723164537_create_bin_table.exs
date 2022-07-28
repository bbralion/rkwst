defmodule Rkwst.Repo.Migrations.CreateBinTable do
  use Ecto.Migration

  def change do
    create table(:bins, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :endpoint, :string
      add :created, :utc_datetime
      add :last, :utc_datetime
      add :deadline, :utc_datetime
      add :count, :integer
    end
  end
end
