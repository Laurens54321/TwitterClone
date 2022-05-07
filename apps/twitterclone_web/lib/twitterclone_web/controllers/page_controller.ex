defmodule TwittercloneWeb.PageController do
  use TwittercloneWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def unauthorized(conn, _params) do
    put_status(conn, 401)
    render(conn, "index.html", error: "You are not authorized to do that")
  end

end
