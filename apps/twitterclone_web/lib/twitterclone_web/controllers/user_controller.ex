defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.User

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

  defp processchangeset(%{"changeset" => changeset}), do: changeset
  defp processchangeset(%{}), do: UserContext.change_user(%User{})

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.profile_path(conn, :profile, user.user_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        redirect(conn, to: Routes.user_path(conn, :new, changeset))
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    current_user = Guardian.Plug.current_resource(conn)
    if isAuthorized(current_user, user) do
      changeset = UserContext.change_user(user)
      roles = UserContext.get_acceptable_roles()
      render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
    else
      redirect(conn, to: Routes.page_path(conn, :unauthorized))
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end



  defp isAuthorized(%User{} = current_user, user) do
    cond do
      UserContext.hasrole(current_user, ["Admin", "Manager"]) ->
        true
      user.user_id == current_user.user_id ->
        true
      true -> false
    end
  end

  defp isAuthorized(_var, _user), do: false

end
