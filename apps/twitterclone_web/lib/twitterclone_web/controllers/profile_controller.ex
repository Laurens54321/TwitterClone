defmodule TwittercloneWeb.ProfileController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  def myprofile(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_by_userid(current_user.user_id, [:api_key, twats: [:user]])
    render(conn, "myprofile.html", user: user, twats: user.twats)
  end

  def feed(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    following = UserContext.get_following(current_user.user_id)
    if following == [] do
      render(conn, "feed.html", twats: [])
    end
    twats = List.flatten(TwatContext.get_by_userid_list(following, [:user]))
    render(conn, "feed.html", twats: twats)
  end

  def profile(conn, %{"user_id" => user_id}) do
    user = UserContext.get_by_userid(user_id, [:twats, :followers, :api_key, twats: [:user]])
    current_user = Guardian.Plug.current_resource(conn)
    if current_user.user_id == user.user_id, do: redirect(conn, to: Routes.profile_path(conn, :myprofile))
    if current_user == nil, do: render(conn, "profile.html", user: user, twats: user.twats)
    following = current_user in user.followers
    render(conn, "profile.html", user: user, twats: user.twats, follow_button: getfollowbutton(following))
  end

  defp getfollowbutton(isFollowing) do
    if isFollowing do
      "followbutton_unfollow.html"
    else
      "followbutton_follow.html"
    end
  end

  def newtwat(conn, _params) do
    changeset = TwatContext.change_twat(%Twat{})
    render(conn, "twat.html", changeset: changeset)
  end

  def createtwat(conn, %{"twat" => twat_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    twat_params
      |> Map.put("user_id", current_user.user_id)
      |> TwatContext.create_twat()

      redirect(conn, to: "/profile")
  end

  def createcomment(conn, %{"comment" => comment_params, "twat_id" => twat_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    comment_params
      |> Map.put("user_id", current_user.user_id)
      |> Map.put("twat_id", twat_id)
      |> Twitterclone.CommentContext.create_comment()

      redirect(conn, to: Routes.twat_path(conn, :get, twat_id))
  end


end
