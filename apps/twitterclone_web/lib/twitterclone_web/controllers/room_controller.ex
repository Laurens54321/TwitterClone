defmodule TwittercloneWeb.RoomController do
  use TwittercloneWeb, :controller
  require Logger

  alias TwittercloneWeb.Guardian
  alias Twitterclone.UserContext
  alias Twitterclone.RoomContext
  alias Twitterclone.RoomContext.VirtualRoom

  def new(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    all_users = UserContext.list_users()
    user_ids = for u <- all_users, do: if (u.user_id != user.user_id), do: u.user_id
    user_ids = Enum.filter(user_ids, fn x -> x != nil end) # remove the nil entry with our userid

    changeset = Twitterclone.RoomContext.change_virtualRoom(%VirtualRoom{})

    render(conn, "new.html", all_users: user_ids, changeset: changeset)
  end

  def create(conn, %{"virtual_room" => %{"name" => roomname, "user_ids" => user_ids}}) do
    user = Guardian.Plug.current_resource(conn)
    user_ids = [user.user_id | user_ids]
    Logger.info "user_ids"
    IO.inspect user_ids
    {:ok, room} = if String.trim(roomname) == "", do: RoomContext.create_room(user_ids), else: RoomContext.create_room(user_ids, roomname)
    redirect(conn, to: "/rooms/#{room.id}")
  end

end
