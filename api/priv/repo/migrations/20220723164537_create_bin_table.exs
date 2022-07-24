defmodule Rkwst.Repo.Migrations.CreateBinTable do
  use Ecto.Migration

  def change do
    create table(:bins, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :endpoint, :string
      add :deadline, :string
    end
  end
end
