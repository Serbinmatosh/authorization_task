defmodule AuthorizationTaskWeb.SessionController do
  use AuthorizationTaskWeb, :controller

  alias AuthorizationTask.Accounts
  alias AuthorizationTask.Guardian

  action_fallback AuthorizationTaskWeb.FallbackController


  # Function called when attempting to create a new Session
  def new(conn, %{"username" => username, "password" => password}) do

    # Switch statement, checks if user is in the DB
    case Accounts.authenticate_user(username, password) do
      {:ok, user} ->
        #If user is in the DB, creates a new Token
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {15, :minute})

          {:ok, refresh_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {7, :day})

          # Return of the Token
          conn
          |> put_resp_cookie("ruid", refresh_token)
          |> put_status(:created)
          |> render("token.json", access_token: access_token)

      # Error handling if user not present in DB
      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "unauthorized"})

        conn
        |> send_resp(401, body)
    end
  end

  # Refreshes the Token for security reasons
  def refresh(conn, _params) do
    refresh_token =
      Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "ruid"])

      case Guardian.exchange(refresh_token, "refresh", "access") do
        {:ok, _old_stuff, {new_access_token, _new_claims}} ->
          conn
          |> put_status(:created)
          |> render("token.json", %{access_token: new_access_token})

        {:error, _reason} ->
          body = Jason.encode!(%{error: "unautorized"})

          conn
          |> send_resp(401, body)
      end
  end

  # Deletes a Token / Logs out the User
  def delete(conn, _params) do
    conn
    |> delete_resp_cookie("ruid")
    |> put_status(200)
    |> text("Log out successful.")
  end
end
