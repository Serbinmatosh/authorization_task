defmodule AuthorizationTask.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias AuthorizationTask.Repo

  alias AuthorizationTask.Accounts.User

  # Creates the user in the DB
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # Retrieves the user from the DB by using username
  def get_by_username(username) do
    query = from u in User, where: u.username == ^username

    case Repo.one(query) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  # Retrieves from DB using an ID
  def get_by_id!(id) do
    User |> Repo.get!(id)
  end

  # Authenticates user
  def authenticate_user(username, password) do
    # Checks validation for User by username param
    with{:ok, user} <- get_by_username(username) do
      # Switch that validates password for said username
      case validate_password(password, user.password) do
        false -> {:error, :unauthorized}
        true -> {:ok, user}
      end
    end
  end

  # Checks if the password matches the encrypted password in the DB
  def validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end
end
