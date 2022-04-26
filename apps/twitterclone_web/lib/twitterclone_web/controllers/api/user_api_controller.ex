defmodule TwittercloneWeb.UserAPIController do
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
    user = UserContext.get_user(user_id)
    render(conn, "show.json", user: user)
  end

  def adminshow(conn, %{"id" => user_id}) do
    user = UserContext.get_user(user_id)
    render(conn, "adminshow.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case UserContext.get_user!(id) do
      {:ok, user} ->
        case UserContext.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: Routes.user_path(conn, :show, user))
          {:error, %Ecto.Changeset{}} ->
            send_resp(conn, 400, "Could not update user.")
        end
      nil ->
        send_resp(conn, 400, "Could not find user with that id.")
    end
  end

  def delete(conn, %{"id" => id}) do
    case UserContext.get_user!(id) do
      {:ok, user} ->
        UserContext.delete_user(user)
      nil ->
        send_resp(conn, 400, "Could not find user with that id.")
      end

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end


end
