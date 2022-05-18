defmodule TwittercloneWeb.CommentAPIView do
  use TwittercloneWeb, :view
  alias TwittercloneWeb.CommentAPIView

  def render("index.json", %{comments: comments}) do
    render_many(comments, CommentAPIView, "comment.json", as: :comment)
  end

  def render("show.json", %{comment: comment}) do
    render_one(comment, CommentAPIView, "comment.json", as: :comment)
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      text: comment.text,
      user_id: comment.user_id,
      twat_id: comment.twat_id,
      inserted_at: comment.inserted_at
    }
  end
end
