defmodule Rkwst.Repo do
  use Ecto.Repo,
    otp_app: :rkwst,
    adapter: Ecto.Adapters.Postgres
end
