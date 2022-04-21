defmodule Twitterclone.CommentContext.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :text, :string
    belongs_to :twat, Twitterclone.TwatContext.Twat
    belongs_to :user, Twitterclone.UserContext.User, foreign_key: :user_id, references: :user_id, type: :string


    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :user_id, :twat_id])
    |> validate_required([:text, :user_id, :twat_id])
  end
end
