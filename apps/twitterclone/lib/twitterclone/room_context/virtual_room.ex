defmodule Twitterclone.RoomContext.VirtualRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "virtualrooms" do
    field :name, :string
    field :user_ids, {:array, :string}, virtual: true

    timestamps()
  end

  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:name, :user_ids])
    |> validate_required([:name, :user_ids])
  end
end
