defmodule TwittercloneWeb.UserAPIController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext

  action_fallback TwittercloneWeb.APIFallbackController

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- UserContext.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user.user_id))
      |> render("user.json", user: user)
    end
  end

  def show(conn, %{"id" => user_id}) do
    with {:ok, user} <- UserContext.get_user(user_id) do
      render(conn, "show.json", user: user)
    end
  end

  def adminshow(conn, %{"id" => user_id}) do
    with {:ok, user} <- UserContext.get_user(user_id, [:api_key]) do
      render(conn, "adminshow.json", user: user, api_key: user.api_key)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if id == conn.assigns.current_api_user.user_id do
      with {:ok, user} <- UserContext.get_user(id) do
        with {:ok, user} <- UserContext.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
      end
    else
      {:error, :unauthorized}
    end
  end

  def delete(conn, %{"id" => id}) do
    if id != conn.assigns.current_api_user.userid, do: {:error, :unauthorized}
    with {:ok, user} <- UserContext.get_user(id) do
      UserContext.delete_user(user)
      conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end
end
