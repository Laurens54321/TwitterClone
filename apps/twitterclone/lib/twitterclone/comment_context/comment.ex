defmodule Twitterclone.CommentContext.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment_id, :string
    field :creationDate, :date
    field :text, :string
    belongs_to :twat, Twitterclone.TwatContext.Twat
    belongs_to :user, Twitterclone.UserContext.User, foreign_key: :user_id, references: :user_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment_id, :text, :creationDate])
    |> validate_required([:comment_id, :text, :creationDate])
  end
end
