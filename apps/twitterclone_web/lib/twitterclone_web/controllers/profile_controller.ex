defmodule TwittercloneWeb.ProfileController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  #alias Twitterclone.UserContext.User
  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat
  alias Twitterclone.UserContext.Follower
  alias Twitterclone.RoomContext

  action_fallback TwittercloneWeb.FallbackController

  def myprofile(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, user} = UserContext.get_by_userid(current_user.user_id, [:api_key, twats: [:user, :comments]])
    render(conn, "myprofile.html", user: user, twats: user.twats, title: "My Profile")
  end

  def feed(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    following = UserContext.get_following(current_user.user_id)
    twats = TwatContext.get_by_userid_list(following, [:user, :comments])
    rooms = RoomContext.get_by_userid(current_user.user_id, [:messages])
    render(conn, "feed.html", twats: twats, title: "Feed", rooms: rooms)
  end

  def profile(conn, %{"user_id" => user_id}) do
    with {:ok, user} <- UserContext.get_by_userid(user_id, [:twats, :followers, :api_key, twats: [:user, :comments]]) do
      current_user = Guardian.Plug.current_resource(conn)
      cond do
        current_user == nil ->
          render(conn, "profile.html", user: user, twats: user.twats, title: "Profile")
        current_user.user_id == user.user_id ->
          redirect(conn, to: Routes.profile_path(conn, :myprofile))
        true ->
          following = current_user in user.followers
          render(conn, "profile.html", user: user, twats: user.twats, follow_button: getfollowbutton(following), title: "Profile")
      end
    end
  end

  defp getfollowbutton(isFollowing) do
    if isFollowing do
      "followbutton_unfollow.html"
    else
      "followbutton_follow.html"
    end
  end

  def newtwat(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = TwatContext.change_twat(%Twat{}, %{user_id: current_user.user_id})
    render(conn, "twat.html", changeset: changeset, title: "Twat Something!")
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
      redirect(conn, to: Routes.twat_path(conn, :show, twat_id))
  end

  def follow(conn, %{"user_id" => user_id, "follower_id" => follower_id}) do
    with true <- Guardian.Plug.current_resource(conn).user_id == follower_id do
        with {:ok, %Follower{}} <- UserContext.create_follower(%{user_id: user_id, follower_id: follower_id}) do
          conn
          |> redirect(to: Routes.profile_path(conn, :profile, user_id))
        end
      else
        {:error, _} -> {:error, :unauthorized}
        false -> {:error, :unauthorized}
      end
  end

  def unfollow(conn, %{"user_id" => user_id, "follower_id" => follower_id}) do
    with true <- Guardian.Plug.current_resource(conn).user_id == follower_id do
      with {:ok, %Follower{}} <- UserContext.delete_follower(UserContext.get_follower_record(user_id, follower_id)) do
        conn
        |> redirect(to: Routes.profile_path(conn, :profile, user_id))
      end
    else
      false -> {:error, :unauthorized}
    end
  end

  def oauth_signup(conn, args) do
    IO.inspect(conn)
    oauth_user = UserContext.get_oauth_user_bysub("")
    changeset = UserContext.change_user(%UserContext.User{})
    render(conn, "oath_signup.html", changeset: changeset, oauth_user: oauth_user)
  end

  def update_picture_url(conn, args) do
    current_user = Guardian.Plug.current_resource(conn)
    oauths = UserContext.get_oauth_users(current_user.user_id)
    UserContext.update_user(%{
      picture_url: Enum.at(oauths, 0).picture
    })
    redirect(conn, to: Routes.profile_path(conn, :myprofile))
  end
end
