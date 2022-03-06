defmodule Points.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Points.Repo

  alias Points.Accounts.User
  alias Points.Accounts.UserToken
  alias Points.Accounts.UserNotifier

  def fetch_or_create_user(attrs) do
    case get_user_by_email(attrs.email) do
      %User{} = user -> {:ok, user}
      _ ->
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Confirms a user

  Assumes an OAuth workflow where we trust the provider to know the user's email.
  """
  def confirm_user(%User{confirmed_at: nil} = user) do
    user |> User.confirm_changeset() |> Repo.update()
  end
  def confirm_user(%User{} = user), do: user

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end
end
