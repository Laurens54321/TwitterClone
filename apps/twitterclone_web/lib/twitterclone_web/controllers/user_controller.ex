defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.User


  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, args) do
    changeset = processchangeset(args)
    current_user = Guardian.Plug.current_resource(conn)
    roles = UserContext.get_acceptable_roles(current_user)
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
  end

  defp processchangeset(%Ecto.Changeset{} = changeset), do: changeset
  defp processchangeset(%{}), do: UserContext.change_user(%User{})

  defp controlchangesetroles?(%{"role" => role}, acceptable_roles) do
    role in acceptable_roles
  end

  def create(conn, %{"user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    roles = UserContext.get_acceptable_roles(current_user)
    if not controlchangesetroles?(user_params, roles), do: {:error, "unauthorized"}
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.profile_path(conn, :profile, user.user_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        new(conn,changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- UserContext.get_by_userid(id) do
      render(conn, "show.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- UserContext.get_by_userid(id) do
      changeset = UserContext.change_user(user)
      roles = UserContext.get_acceptable_roles()
      render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, %User{} = user} <- UserContext.get_by_userid(id) do
      case UserContext.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.profile_path(conn, :profile, user.user_id))

        {:error, %Ecto.Changeset{} = changeset} ->
          roles = UserContext.get_acceptable_roles()
          render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
