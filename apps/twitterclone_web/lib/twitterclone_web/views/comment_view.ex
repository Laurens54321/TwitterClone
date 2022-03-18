defmodule TwittercloneWeb.CommentView do
  use TwittercloneWeb, :view
  alias TwittercloneWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      comment_id: comment.comment_id,
      text: comment.text,
      creationDate: comment.creationDate
    }
  end
end
