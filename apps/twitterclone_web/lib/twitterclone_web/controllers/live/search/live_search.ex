defmodule TwittercloneWeb.LiveSearch do
  use TwittercloneWeb, :live_view
  require Logger

  alias Twitterclone.UserContext
  alias Twitterclone.RoomContext

  @impl true
  def mount(params, session, socket) do
    {:ok, user, _idk} = Guardian.resource_from_token(TwittercloneWeb.Guardian, session["guardian_default_token"])
    {:ok, assign(socket,
        user: user,
        searchForm: "",   # Form to store the search
        searchresults: [],  # Search result list with items
        roomsearchresults: [],  # Search result list with %Room{}'s
        userids: [])}       # List of selected user's user_ids
  end

  @impl true
  def handle_event("form_update", %{"search" => %{"search" => search}}, socket) do
    usersearchresults = UserContext.search_users(search)
    |> drop_selected([socket.assigns.user.user_id | socket.assigns.userids])
    twatsearchresults = Twitterclone.TwatContext.search_twats(search)
    roomsearchresults = Twitterclone.RoomContext.search_rooms(search)
    form = Enum.join([search | socket.assigns.userids], ", ")
    {:noreply, assign(socket, searchForm: form, searchresults: usersearchresults ++ twatsearchresults, roomsearchresults: roomsearchresults)}
  end

  @impl true
  def handle_event("form_update", %{"room" => %{"name" => name}}, socket) do
    {:noreply, TwittercloneWeb.handle_live_blazeit(socket, name)}
  end

  @impl true
  def handle_event("select-user", %{"user" => user_id}, socket) do
    {:noreply, redirect(socket, to: Routes.profile_path(socket, :profile, user_id))}
  end

  @impl true
  def handle_event("select-twat", %{"twat" => twat_id}, socket) do
    {:noreply, redirect(socket, to: Routes.twat_path(socket, :show, twat_id))}
  end

  @impl true
  def handle_event("submit_room", %{"room" => %{"name" => name}}, socket) do
    user_ids = [socket.assigns.user.user_id | socket.assigns.userids]
    {:ok, room} = if String.trim(name) == "",
      do: RoomContext.create_room(user_ids),
      else: RoomContext.create_room(user_ids, name)
    {:noreply, redirect(socket, to: "/rooms/#{room.id}")}
  end

  defp drop_selected(userlist, userids) do
    Enum.reject(userlist,
      fn user -> Enum.any?(userids,
        fn selecteduserid ->
          String.equivalent?(user.user_id, selecteduserid)
        end)
      end)
  end

end
