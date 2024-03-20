defmodule ElectroDb.Repo do
  use Ecto.Repo,
    otp_app: :electro_db,
    adapter: Ecto.Adapters.Postgres
end
