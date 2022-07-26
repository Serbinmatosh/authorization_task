defmodule AuthorizationTask.Repo do
  use Ecto.Repo,
    otp_app: :authorization_task,
    adapter: Ecto.Adapters.Postgres
end
