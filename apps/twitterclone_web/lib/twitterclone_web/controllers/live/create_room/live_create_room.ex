defmodule TwittercloneWeb.LiveCreateRoom do
  use TwittercloneWeb, :live_view
  require Logger

  alias Twitterclone.UserContext
  alias Twitterclone.RoomContext

  @impl true
  def mount(params, session, socket) do
    {:ok, user, _idk} = Guardian.resource_from_token(TwittercloneWeb.Guardian, session["guardian_default_token"])
    {:ok, assign(socket,
        user: user,
        usernameForm: "",   # Form to store the search
        searchresults: [],  # Search result list with %User{}'s
        userids: [])}       # List of selected user's user_ids
  end

  @impl true
  def handle_event("form_update", %{"search" => %{"search" => search}}, socket) do
    searchresults = UserContext.search_users(search)
    |> drop_selected([socket.assigns.user.user_id | socket.assigns.userids])
    form = Enum.join([search | socket.assigns.userids], ", ")
    {:noreply, assign(socket, usernameForm: form, searchresults: searchresults)}
  end

  @impl true
  def handle_event("form_update", %{"room" => %{"name" => name}}, socket) do
    {:noreply, TwittercloneWeb.handle_live_blazeit(socket, name)}
  end

  @impl true
  def handle_event("select-user", %{"user" => user_id}, socket) do
    userids = socket.assigns.userids
    if Enum.member?(userids, user_id) do
      {:noreply, socket}
    else
      newuserids = socket.assigns.userids ++ [user_id]
      searchresults = socket.assigns.searchresults
      |> drop_selected([user_id])
      form = Enum.join(newuserids, ", ")
      {:noreply, assign(socket, userids: newuserids, searchresults: searchresults, usernameForm: form)}
    end
  end

  @impl true
  def handle_event("unselect-user", %{"user" => user_id}, socket) do
    userids = socket.assigns.userids
    |> Enum.reject(fn x -> x == user_id end)
    {:noreply, assign(socket, userids: userids)}
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
