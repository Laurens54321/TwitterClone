defmodule Twitterclone.RoomContext do
  @moduledoc """
  The TwatContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo

  require Logger

  alias Twitterclone.RoomContext.Room
  alias Twitterclone.RoomContext.Message
  alias Twitterclone.RoomContext.RoomConnection
  alias Twitterclone.RoomContext.VirtualRoom
  alias Twitterclone.Preloader

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

  def get_message(id, preloads \\ []) do
    case Repo.get(Message, id) do
      nil -> {:error, :not_found}
      mesage ->
        {:ok, Repo.preload(mesage, preloads)}
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

  def create_message(user_id, room_id, text, []) do
    %Message{}
     |>Message.changeset(%{user_id: user_id, room_id: room_id, text: text })
     |>Repo.insert()
  end

  def create_message(user_id, room_id, text, replytomsgid) do
    %Message{}
     |>Message.changeset(%{user_id: user_id, room_id: room_id, text: text, replyto_id: replytomsgid })
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
      list ->
        msgs = for n <- list, do: Repo.preload(n, preloads)
        {:ok, msgs}
    end
  end

  def get_room_messages(room_id) do
    base = from(msg in Twitterclone.RoomContext.Message)
    query = from(u in base,
      left_join: user in assoc(u, :user),
      on: like(u.user_id, user.user_id),
      left_join: replytomsg in assoc(u, :replyto),
      on: u.replyto_id == replytomsg.id,
      where: u.room_id == ^room_id,
      preload: [user: user],
      preload: [replyto: replytomsg])
    case Repo.all(query) do
      Ecto.QueryError -> {:error, :not_found}
      msgs ->
        {:ok, msgs}
    end
  end

  def get_room_paginated(room_id, page, per_page \\ 30) do
    offset_by = per_page * page
    query = from(u in Twitterclone.RoomContext.Message,
      where: u.room_id == ^room_id,

      left_join: user in assoc(u, :user),
      on: like(u.user_id, user.user_id),
      left_join: replytomsg in assoc(u, :replyto),
      on: u.replyto_id == replytomsg.id,

      preload: [user: user],
      preload: [replyto: replytomsg],

      order_by: [desc: u.inserted_at],
      limit: ^per_page,
      offset: ^offset_by
    )
    case Repo.all(query) do
      Ecto.QueryError -> {:error, :not_found}
      msgs ->
        {:ok, msgs}
    end
  end

  def compare_msg_time(x, y), do: NaiveDateTime.diff(x.inserted_at, y.inserted_at) > 600

  def compare_msg_prof(x, y), do: x.user_id != y.user_id

  def put_show_time(messages) do
    msg_amount = Enum.count(messages) - 1
    if msg_amount == -1 do
      []
    else
      for x <- 0..msg_amount do
        cond do
          msg_amount == 0 -> %{Enum.at(messages, 0) | showtime: true, showprof: true}
          x == 0 -> %{Enum.at(messages, 0) | showtime: true, showprof: true}
          msg_amount > 0 && x > 0 ->
            elem = Enum.at(messages, x)
            prev_elem = Enum.at(messages, x - 1)
            %{elem | showtime: compare_msg_time(elem, prev_elem), showprof: compare_msg_prof(elem, prev_elem)}
        end
      end
    end
  end

  def search_rooms(search_phrase) do
    start_character = String.slice(search_phrase, 0..1)

    from(
      p in Room,
      where: ilike(p.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0",  p.name, ^search_phrase),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.name, ^search_phrase)
    )
    |> Repo.all()
  end
end
