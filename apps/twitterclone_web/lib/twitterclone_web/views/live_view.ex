defmodule TwittercloneWeb.LiveView do
  use TwittercloneWeb, :view

  def rendermsgreceived(message) do
    Phoenix.View.render(TwittercloneWeb.LiveView, "live_message_rec.html", message: message)
  end

  def rendermsgsent(message) do
    Phoenix.View.render(TwittercloneWeb.LiveView, "live_message_sent.html", message: message)
  end
end
