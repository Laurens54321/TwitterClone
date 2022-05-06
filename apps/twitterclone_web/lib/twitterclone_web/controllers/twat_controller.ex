defmodule TwittercloneWeb.TwatController do
  use TwittercloneWeb, :controller

  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat
  alias Twitterclone.CommentContext
  alias Twitterclone.CommentContext.Comment

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    twats = TwatContext.list_twats()
    render(conn, "index.json", twats: twats)
  end

  def create(conn, %{"twat" => twat_params}) do
    with {:ok, %Twat{} = twat} <- TwatContext.create_twat(twat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.twat_path(conn, :show, twat))
      |> render("show.json", twat: twat)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, twat} <- TwatContext.get_twat(id, [:user, :comments, comments: [:user]]) do
      changeset = CommentContext.change_comment(%Comment{})
      render(conn, "twatpage.html", twat: twat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    twat = TwatContext.get_twat!(id)

    with {:ok, %Twat{}} <- TwatContext.delete_twat(twat) do
      send_resp(conn, :no_content, "")
    end
  end
end
