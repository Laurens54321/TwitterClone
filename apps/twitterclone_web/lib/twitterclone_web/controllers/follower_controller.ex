defmodule TwittercloneWeb.FollowerController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.Follower

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user_id" => user_id, "follower_id" => follower_id}) do
    if Guardian.Plug.current_resource(conn).user_id != follower_id do
      conn
      |> put_status(:failed)
      |> render("credentials.json", follower: follower_id)
    end
    with {:ok, %Follower{} = follower} <- UserContext.create_follower(%{user_id: user_id, follower_id: follower_id}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.follower_path(conn, :show, follower))
      |> render("show.json", follower: follower)
    end
  end

  def show(conn, %{"id" => id}) do
    follower = UserContext.get_follower!(id)
    render(conn, "show.json", follower: follower)
  end

  def delete(conn, %{"id" => id}) do
    follower = UserContext.get_follower!(id)

    with {:ok, %Follower{}} <- UserContext.delete_follower(follower) do
      send_resp(conn, :no_content, "")
    end
  end
end
