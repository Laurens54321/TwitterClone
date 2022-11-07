defmodule Twitterclone.RoomContext do
  @moduledoc """
  The TwatContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo

  alias Twitterclone.UserContext.Follower
  alias Twitterclone.TwatContext.Twat

  alias Twitterclone.RoomContext.Room
  alias Twitterclone.RoomContext.Message
  alias Twitterclone.RoomContext.RoomConnection
  alias Twitterclone.RoomContext.VirtualRoom

  def list_rooms do
    Repo.all(Room)
  end

  def get_room!(id, preloads \\ []) do
    Repo.get!(Room, id)
     |> Repo.preload(preloads)
  end
  def get_room(id, preloads \\ []) do
    case Repo.get(Room, id) do
      nil -> {:error, :not_found}
      room ->
        {:ok, Repo.preload(room, preloads)}
    end
  end

  def get_by_userid(user_id, preloads \\ []) do
    query = from(u in RoomConnection, where: u.user_id == ^user_id)
    case Repo.all(query) do
      nil -> {:error, :not_found}
      Ecto.QueryError -> {:error, :not_found}
      [] -> []
      list ->
        for n <- list do
          get_room!(n.room_id, preloads)
        end
    end
  end

  def is_user_in_room(user_id, room_id) do
    query = from(u in RoomConnection, where: like(u.user_id, ^user_id) and u.room_id == ^room_id)
    case Repo.all(query) do
      nil -> false
      Ecto.QueryError -> {:error, :queryError}
      [] -> false
      list ->
        true
    end
  end

  def create_room(user_list) do
    create_room(user_list, Enum.join(user_list, ", "))
  end

  def create_room(user_list, name) do
    {:ok, room} = %Room{}
     |>Room.changeset(%{name: name})
     |>Repo.insert()

    for user_id <- user_list do
      {:ok, _connection} = create_connection(user_id, room.id)
    end
    {:ok, room}
  end

  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def add_newmsg(room_id, sender_id) do
    {:ok, room} = get_room(room_id, [:users])
    user_ids = for user <- room.users, do: user.user_id
    IO.inspect user_ids
    user_ids = Enum.filter(user_ids, fn x -> x != sender_id end)

    IO.inspect user_ids

    room
    |> Room.changeset(%{newmsg: user_ids})
    |> Repo.update()
  end

  def remove_newmsg(room_id, sender_id) do
    {:ok, room} = get_room(room_id)
    user_ids = Enum.filter(room.newmsg, fn x -> x != sender_id end)
    IO.inspect user_ids

    room
    |> Room.changeset(%{newmsg: user_ids})
    |> Repo.update()
  end

  defp create_connection(user_id, room_id) do
    %RoomConnection{}
      |>RoomConnection.changeset(%{user_id: user_id, room_id: room_id})
      |>Repo.insert()
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def change_virtualRoom(%VirtualRoom{} = virtual_room, attrs \\ %{}) do
    VirtualRoom.changeset(virtual_room, attrs)
  end


  def create_message(user_id, room_id, text) do
    %Message{}
     |>Message.changeset(%{user_id: user_id, room_id: room_id, text: text })
     |>Repo.insert()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_messages(room_id, preloads \\ []) do
    query = from(u in Message, where: u.room_id == ^room_id)
    case Repo.all(query) do
      Ecto.QueryError -> {:error, :not_found}
      [] -> []
      list ->
        for n <- list, do: Repo.preload(n, preloads)
    end
  end

end
