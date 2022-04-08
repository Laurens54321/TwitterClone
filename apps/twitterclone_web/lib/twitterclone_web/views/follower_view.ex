defmodule TwittercloneWeb.FollowerView do
  use TwittercloneWeb, :view
  alias TwittercloneWeb.FollowerView

  def render("index.json", %{followers: followers}) do
    %{data: render_many(followers, FollowerView, "follower.json")}
  end

  def render("show.json", %{follower: follower}) do
    %{data: render_one(follower, FollowerView, "follower.json")}
  end

  def render("follower.json", %{follower: follower}) do
    %{
      id: follower.id,
      user_id: follower.user_id,
      follower_id: follower.follower_id
    }
  end

  def render("credentials.json", %{follower: follower}) do
    %{
      error: "Not authenticated as following user: " <> follower
    }
  end
end
