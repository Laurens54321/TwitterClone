defmodule Twitterclone.TwatContext.Twat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "twats" do
    field :twat_id, :string
    field :creationDate, :date
    field :text, :string
    belongs_to :user, Twitterclone.UserContext.User
    has_many :comments, Twitterclone.CommentContext.Comment

    timestamps()
  end

  @doc false
  def changeset(twat, attrs) do
    twat
    |> cast(attrs, [:twat_id, :text, :creationDate, :user_id])
    |> validate_required([:twat_id, :text, :creationDate, :user_id])
  end
end
