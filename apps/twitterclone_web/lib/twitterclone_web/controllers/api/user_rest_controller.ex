defmodule TwittercloneWeb.UserRestController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("user.json", user: user)

      {:error, _cs} -> # If creation failed, let the end user know about the failure.
        conn
        |> send_resp(400, "Something went wrong, sorry.")
    end
  end

  def show(conn, %{"id" => user_id}) do
    user = UserContext.get_user(user_id, [:twats])
    render(conn, "show.json", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
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


end
