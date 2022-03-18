defmodule Twitterclone.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :user_id, :string
    field :email, :string
    field :name, :string
    field :passwordHash, :string
    has_many :tasks, Twitterclone.TwatContext.Twat
    has_many :comments, Twitterclone.CommentContext.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :name, :email, :passwordHash])
    |> validate_required([:user_id, :name, :email, :passwordHash])
  end
end
