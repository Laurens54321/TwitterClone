defmodule Twitterclone.TwatContext.Twat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User
  alias Twitterclone.TwatContext.Twat

  schema "twats" do
    field :text, :string
    belongs_to :user, User, foreign_key: :user_id, references: :user_id, type: :string

    belongs_to :replyto, Twat
    has_many :comments, Twat, foreign_key: :replyto_id


    timestamps()
  end

  @doc false
  def changeset(twat, attrs) do
    twat
    |> cast(attrs, [:text, :user_id, :replyto_id])
    |> validate_required([:text, :user_id])
    |> foreign_key_constraint(:user_id, name: :twats_user_id_fkey)
    #|> foreign_key_constraint(:replyto_id, name: :twats_replyto_id_fkey)
  end

end
