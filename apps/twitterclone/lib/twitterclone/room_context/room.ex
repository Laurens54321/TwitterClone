defmodule Twitterclone.RoomContext.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.RoomContext.RoomConnection


  schema "rooms" do
    field :name, :string

    has_many :connection, Twitterclone.RoomContext.RoomConnection, on_delete: :nothing
    has_many :message, Twitterclone.RoomContext.Message
    field :user_ids, {:array, :string}, virtual: true


    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
