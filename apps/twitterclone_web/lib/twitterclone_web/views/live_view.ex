defmodule TwittercloneWeb.LiveView do
  use TwittercloneWeb, :view

  def rendermsg(message) do
    Phoenix.View.render(TwittercloneWeb.LiveView, "live_message.html", message: message)
end
end
