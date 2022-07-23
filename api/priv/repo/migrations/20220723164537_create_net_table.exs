defmodule Rkwst.Repo.Migrations.CreateNetTable do
  use Ecto.Migration

  def change do
    create table(:nets) do
      add :endpoint, :string
      add :deadline, :string

      timestamps
    end
  end
end
