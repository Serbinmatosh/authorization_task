defmodule AuthorizationTask.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuthorizationTask.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        first_name: "some first_name",
        last_name: "some last_name",
        password: "some password",
        username: unique_user_username()
      })
      |> AuthorizationTask.Accounts.create_user()

    user
  end
end
