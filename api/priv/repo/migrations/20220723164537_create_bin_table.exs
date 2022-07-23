defmodule Rkwst.Repo.Migrations.CreateBinTable do
  use Ecto.Migration

  def change do
    create table(:bins) do
      add :endpoint, :string
      add :deadline, :string

      timestamps
    end
  end
end
