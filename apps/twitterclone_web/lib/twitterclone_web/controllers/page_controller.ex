defmodule TwittercloneWeb.PageController do
  use TwittercloneWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
