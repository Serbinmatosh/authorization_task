defmodule AuthorizationTaskWeb.UserController do
  use AuthorizationTaskWeb, :controller

  alias AuthorizationTask.Accounts
  alias AuthorizationTask.Accounts.User

  action_fallback AuthorizationTaskWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> text("User successfully registeres with email:" <> " " <> user.email)
    end
  end
end
