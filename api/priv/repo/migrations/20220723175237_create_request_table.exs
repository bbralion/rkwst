defmodule Rkwst.Repo.Migrations.CreateRequestTable do
  use Ecto.Migration

  def change do
    create table(:requests, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :ip, :string
      add :proto, :string
      add :timestamp, :utc_datetime
      add :method, :string
      add :uri, :string
      add :headers, :map
      add :form, :map
      add :files, :map
      add :body, :string
      add :bin_id, references(:bins, type: :uuid, on_delete: :delete_all)
    end

    create index(:requests, [:bin_id])
  end
end
