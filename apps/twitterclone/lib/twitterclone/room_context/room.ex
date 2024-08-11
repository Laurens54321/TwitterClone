defmodule Twitterclone.RoomContext.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.RoomContext.RoomConnection


  schema "rooms" do
    field :name, :string

    many_to_many :users,
                 Twitterclone.UserContext.User,
                 join_through: Twitterclone.RoomContext.RoomConnection,
                 join_keys: [room_id: :id, user_id: :user_id]
    has_many :messages, Twitterclone.RoomContext.Message
    field :newmsg, {:array, :string}


    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:name, :newmsg])
    |> validate_required([:name])
  end
end
