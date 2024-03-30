defmodule TodoOffline.Repo do
  use Ecto.Repo,
    otp_app: :todo_offline,
    adapter: Ecto.Adapters.Postgres
end
