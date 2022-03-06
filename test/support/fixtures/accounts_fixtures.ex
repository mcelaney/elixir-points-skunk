defmodule Points.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Points.Accounts` context.
  """

  alias Points.Accounts

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.fetch_or_create_user()

    user
  end
end
