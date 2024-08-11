defmodule Twitterclone.RoomContext.RoomConnection do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roomconnections" do
    belongs_to :user, Twitterclone.UserContext.User, foreign_key: :user_id, references: :user_id, type: :string
    belongs_to :room, Twitterclone.RoomContext.Room
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end

end
