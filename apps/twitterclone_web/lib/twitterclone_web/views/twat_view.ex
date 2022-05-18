defmodule TwittercloneWeb.TwatView do
  use TwittercloneWeb, :view

  def isMyTwat?(conn, twat) do
    case Guardian.Plug.current_resource(conn) do
      nil -> false
      user -> user.user_id == twat.user_id
    end
  end
end
