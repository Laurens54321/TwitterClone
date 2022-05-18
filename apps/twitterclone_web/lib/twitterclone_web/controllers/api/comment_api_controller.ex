defmodule TwittercloneWeb.CommentAPIController do
  use TwittercloneWeb, :controller

  alias Twitterclone.CommentContext
  alias Twitterclone.CommentContext.Comment


  action_fallback TwittercloneWeb.APIFallbackController

  def index(conn, _params) do
    comments = CommentContext.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    if comment_params["user_id"] == conn.assigns.current_api_user.user_id do
      with {:ok, %Comment{} = comment} <- CommentContext.create_comment(comment_params) do
        conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.comment_api_path(conn, :show, comment))
          |> render("show.json", comment: comment)
      end
    else
      {:error, :unauthorized}
    end

  end

  def show(conn, %{"id" => id}) do
    with {:ok, comment} <- CommentContext.get_comment(id) do
      render(conn, "show.json", comment: comment)
    end

  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Comment{} = comment} <- CommentContext.get_comment(id) do
      if comment.user_id == conn.assigns.current_api_user.user_id do
        with {:ok, _} <- CommentContext.delete_comment(comment) do
          send_resp(conn, 202, "")
        end
      else
        {:error, :unauthorized}
      end

    end
  end
end
