defmodule TwittercloneWeb.ProfileController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  def myprofile(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_by_userid(current_user.user_id, [:twats, twats: [:user]])
    render(conn, "profile.html", user: user, twats: user.twats)
  end

  def feed(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    following = UserContext.get_following(current_user.user_id)
    if following == [] do
      render(conn, "feed.html", twats: [])
    end
    [head | _] = TwatContext.get_by_userid_list(following, [:user])
    render(conn, "feed.html", twats: head)
  end

  def profile(conn, %{"user_id" => user_id}) do
    user = UserContext.get_by_userid(user_id, [:twats, :followers, twats: [:user]])
    current_user = Guardian.Plug.current_resource(conn)
    if current_user == nil, do: render(conn, "profile.html", user: user, twats: user.twats)
    following =  current_user.user_id in user.followers
    render(conn, "profile.html", user: user, twats: user.twats, following: following)
  end

  def newtwat(conn, _params) do
    changeset = TwatContext.change_twat(%Twat{})
    render(conn, "twat.html", changeset: changeset)
  end

  def createtwat(conn, %{"twat" => twat_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    twat_params
      |> Map.put("user_id", current_user.user_id)
      |> Map.put("creationDate", DateTime.utc_now)
      |> TwatContext.create_twat()

    redirect(conn, to: "/profile")
  end


end
