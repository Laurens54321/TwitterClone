defmodule TwittercloneWeb.FollowerController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.Follower

  action_fallback TwittercloneWeb.FallbackController

  def followers(conn, %{"user_id" => user_id}) do
    followers = UserContext.get_followers(user_id)
    render(conn, "followers.html", list: followers)
  end

  def following(conn, %{"user_id" => user_id}) do
    following = UserContext.get_following(user_id)
    render(conn, "following.html", list: following)
  end

  def show(conn, %{"id" => id}) do
    follower = UserContext.get_follower!(id)
    render(conn, "show.json", follower: follower)
  end
end
