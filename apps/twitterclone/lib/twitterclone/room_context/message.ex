defmodule Twitterclone.RoomContext.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User

  schema "messages" do
    field :text, :string

    belongs_to :room, Twitterclone.RoomContext.Room
    belongs_to :user, User, foreign_key: :user_id, references: :user_id, type: :string

    belongs_to  :replyto, Twitterclone.RoomContext.Message
    has_many :replies, Twitterclone.RoomContext.Message, foreign_key: :replyto

    field :showtime, :boolean, virtual: true, default: false

    timestamps()
  end


  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id, :replyto_id])
    |> validate_required([:text, :user_id, :room_id])
    |> foreign_key_constraint(:user_id, name: :messages_user_id_fkey)
    |> foreign_key_constraint(:room_id, name: :messages_room_id_fkey)
  end

end
