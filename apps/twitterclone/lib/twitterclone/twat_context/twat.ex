defmodule Twitterclone.TwatContext.Twat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User

  schema "twats" do
    field :creationDate, :date
    field :text, :string
    belongs_to :user, User, foreign_key: :user_id, references: :user_id, type: :string

    has_many :comments, Twitterclone.TwatContext.Twat, foreign_key: :parent_twat
    belongs_to :parent_twats, Twitterclone.TwatContext.Twat, foreign_key: :parent_twat

    timestamps()
  end

  @doc false
  def changeset(twat, attrs) do
    twat
    |> cast(attrs, [:text, :creationDate, :user_id, :parent_twat])
    |> validate_required([:text, :creationDate, :user_id])
  end

end
