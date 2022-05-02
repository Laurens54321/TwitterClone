defmodule Twitterclone.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo

  alias Twitterclone.UserContext.User
  alias Twitterclone.UserContext.ApiKey


  def list_users do
    Repo.all(User)
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

  def get_user(user_id, preloads \\ []) do
    Repo.get(User, user_id)
    |> Repo.preload(preloads)
  end

  def get_by_userid(user_id, preloads \\ []) do
    query = from(u in User, where: like(u.user_id, ^user_id))
    Repo.one(query)
      |> Repo.preload(preloads)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defdelegate get_acceptable_roles(), to: User
  defdelegate get_acceptable_roles(current_user), to: User

  def authenticate_user(user_id, plain_text_password) do
    case Repo.get_by(User, user_id: user_id) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.passwordHash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def preload_feed(user) do
    Repo.preload(user, [{:following, :twats}])
  end

  ### API KEY ###

  def api_key_exists?(%{key: nil}), do: false

  def api_key_exists?(%{key: key}) do
    query = from(u in ApiKey, where: like(u.key, ^key))
    Repo.one!(query)
  end

  def gen_api_key(%User{} = user) do
    user = Repo.preload(user, :api_key)
    case user.api_key do
      nil ->
        %ApiKey{user_id: user.user_id}
      api_key ->
        api_key
    end
    |> ApiKey.changeset(%{key: Twitterclone.key_gen()})
    |> Repo.insert_or_update()
  end


  ### FOLLOWER  ###

  alias Twitterclone.UserContext.Follower

  def list_followers do
    Repo.all(Follower)
  end

  def is_following(user_id, follower_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id) and like(u.follower_id, ^follower_id))
    if Repo.one(query), do: True
    False
  end

  def get_follower!(user_id), do: Repo.get!(Follower, user_id)

  def get_following(user_id) do
    query = from(u in Follower, where: like(u.follower_id, ^user_id))
    Repo.all(query)
  end

  def get_followers(user_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id))
    Repo.all(query)
  end

  def get_follower_record(user_id, follower_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id) and like(u.follower_id, ^follower_id))
    Repo.one(query)
  end

  def create_follower(attrs \\ %{}) do
    %Follower{}
    |> Follower.changeset(attrs)
    |> Repo.insert()
  end

  def update_follower(%Follower{} = follower, attrs) do
    follower
    |> Follower.changeset(attrs)
    |> Repo.update()
  end

  def delete_follower(%Follower{} = follower) do
    Repo.delete(follower)
  end

  def change_follower(%Follower{} = follower, attrs \\ %{}) do
    Follower.changeset(follower, attrs)
  end

end
