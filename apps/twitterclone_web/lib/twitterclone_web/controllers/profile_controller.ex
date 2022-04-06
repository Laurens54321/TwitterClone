defmodule TwittercloneWeb.ProfileController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext
  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  def myprofile(conn, _args) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_by_userid(current_user.user_id, [:twats])
    render(conn, "profile.html", user: user, twats: user.twats)
  end

  def profile(conn, %{"user_id" => user_id}) do
    user = UserContext.get_by_userid(user_id, [:twats])
    render(conn, "profile.html", user: user, twats: user.twats)
  end

  def twat(conn, _params) do
    changeset = TwatContext.change_twat(%Twat{})
    render(conn, "twat.html", changeset)
  end


end
