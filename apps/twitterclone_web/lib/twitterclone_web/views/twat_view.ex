defmodule TwittercloneWeb.TwatView do
  use TwittercloneWeb, :view

  alias Twitterclone.TwatContext.Twat

  def isMyTwat?(conn, twat) do
    case Guardian.Plug.current_resource(conn) do
      nil -> false
      user -> user.user_id == twat.user_id
    end
  end

  def getCommentCount(twat) do
    Enum.count(twat.comments)
  end

end
