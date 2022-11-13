defmodule Twitterclone.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  require Logger

  alias Twitterclone.UserContext.User
  alias Twitterclone.UserContext.ApiKey
  alias Twitterclone.UserContext.OauthUser


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
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user ->
        {:ok, Repo.preload(user, preloads)}
    end
  end

  def get_by_userid(user_id, preloads \\ []) do
    query = from(u in User, where: like(u.user_id, ^user_id))
    case Repo.one(query) do
      nil -> {:error, :not_found}
      user -> {:ok, Repo.preload(user, preloads)}
    end

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

  def update_user(%User{} = user, %{"role" => edit_role} = attrs) do
    if (edit_role in get_acceptable_roles(user)) do
      user
        |> User.changeset(attrs)
        |> Repo.update()
    else
      {:error, :unauthorized}
    end

  end

  def update_user(%User{} = user, attrs) do
    IO.inspect(attrs)
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
  defdelegate get_acceptable_roles(user), to: User

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

  def search_users(search_phrase) do
    start_character = String.slice(search_phrase, 0..1)

    from(
      p in User,
      where: ilike(p.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0",  p.name, ^search_phrase),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.name, ^search_phrase)
    )
    |> Repo.all()
  end

  def create_api_key(attrs \\ %{}) do
    %ApiKey{}
      |> ApiKey.changeset(attrs)
      |> Repo.insert()
  end

  def preload_feed(user) do
    Repo.preload(user, [{:following, :twats}])
  end

  def preload_key(user) do
    Repo.preload user, :api_key
  end

  ### API KEY ###

  def api_key_exists(%{key: nil}), do: false

  def api_key_exists(%{key: key}) do
    query = from(u in ApiKey, where: like(u.key, ^key))
    Repo.one(query)
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

  def hasrole(nil, _roles), do: false
  def hasrole(%User{} = user, roles) do
    Enum.member?(roles, user.role)
  end

  def get_oauth_users(user_id) do
    query = from(u in OauthUser, where: like(u.user_id, ^user_id))
    case Repo.all(query) do
      nil -> {:error, :not_found}
      oauthusers -> {:ok, oauthusers}
    end
  end

  def get_oauth_user_bysub(sub_token, preloads \\ []) do
    query = from(u in OauthUser, where: like(u.sub_token, ^sub_token))
    case Repo.one(query) do
      nil -> {:error, :not_found}
      oauthuser -> {:ok, Repo.preload(oauthuser, preloads)}
    end
  end

  def create_oauth_user(attrs \\ %{}) do
    %OauthUser{}
    |> OauthUser.changeset(attrs)
    |> Repo.insert()
  end

  def update_oauthUser(%OauthUser{} = oauthUser, attrs) do
    oauthUser
    |> OauthUser.changeset(attrs)
    |> Repo.update()
  end

  def authenticate_user_sub(sub_token) do
    query = from(u in User, join: oauth in assoc(u, :oauth_users), where: like(oauth.sub_token, ^sub_token))
    case Repo.one(query) do
      nil -> {:create, :not_found}
      user -> {:ok, user}
    end
  end
end
