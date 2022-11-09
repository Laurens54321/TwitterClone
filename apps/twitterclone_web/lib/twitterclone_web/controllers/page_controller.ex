defmodule TwittercloneWeb.PageController do
  use TwittercloneWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def test(conn, _params) do
    render(conn, "test.html")
  end
  def unauthorized(conn, _params) do
    put_status(conn, 401)
    render(conn, "error.html", error: "You are not authorized to do that")
  end
  def error(conn, %{"errorcode" => errorcode, "error" => error}) do
    {num, _} = Integer.parse errorcode
    put_status(conn, num)
    render(conn, "error.html", error: error)
  end
end
