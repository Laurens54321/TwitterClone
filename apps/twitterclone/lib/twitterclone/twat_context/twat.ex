defmodule Twitterclone.TwatContext.Twat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User

  schema "twats" do
    field :text, :string
    belongs_to :user, User, foreign_key: :user_id, references: :user_id, type: :string

    has_many :comments, Twitterclone.CommentContext.Comment

    timestamps()
  end

  @doc false
  def changeset(twat, attrs) do
    twat
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
    |> foreign_key_constraint(:user_id, name: :twats_user_id_fkey)
  end

end
