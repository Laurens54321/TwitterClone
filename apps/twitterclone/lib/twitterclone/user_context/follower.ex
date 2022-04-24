defmodule Twitterclone.UserContext.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  schema "followers" do
    field :user_id, :string
    field :follower_id, :string

    timestamps()
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> foreign_key_constraint(:user_id, name: :followers_follower_id_fkey)
    |> foreign_key_constraint(:follower_id, name: :followers_user_id_fkey)
    |> unique_constraint([:user_id, :follower_id], name: :follower_user_id_follower_id_match)
    |> unique_constraint([:follower_id, :user_id], name: :follower_follower_id_user_id_match)
  end
end
