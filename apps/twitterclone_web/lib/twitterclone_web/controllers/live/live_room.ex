defmodule TwittercloneWeb.LiveRoom do
  use TwittercloneWeb, :live_view
  require Logger

  alias Twitterclone.RoomContext
  alias Twitterclone.RoomContext.Message

  @impl true
  def mount(%{"room_id" => room_id}, session, socket) do
    {:ok, user, _idk} = Guardian.resource_from_token(TwittercloneWeb.Guardian, session["guardian_default_token"])
    {:ok, room} = RoomContext.get_room(room_id, [messages: [:replyto]])
    topic = "room" <> room_id
    if connected?(socket), do: TwittercloneWeb.Endpoint.subscribe(topic)
    timeids = room.messages
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x, y] -> if(NaiveDateTime.diff(x.inserted_at, y.inserted_at) > 600, do: y.id) end) # show time if message is 600 sec apart = 10 min
    #RoomContext.remove_newmsg(room_id, user.user_id)
    TwittercloneWeb.Presence.track(self(), topic, user.user_id, %{})
    {:ok, assign(socket,
            room: room,
            topic: topic,
            messageForm: "",
            messages: room.messages,
            user: user.user_id,
            replymsg: [],
            showtimeids: timeids
            )}
  end
  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    user_id = socket.assigns.user
    room_id = socket.assigns.room.id
    replymsg = socket.assigns.replymsg
    {:ok, newmsg} = RoomContext.create_message(user_id, room_id, message, replymsg)
    TwittercloneWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", newmsg)
    {:noreply, assign(socket, messageForm: "", replymsg: [])}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, messageForm: message)}
  end

  @impl true
  def handle_event("click-message", %{"id" => id, "message" => message, "userid" => userid}, socket) do
    {:noreply, assign(socket, replymsg: id, replymsgtext: message, replymsguser: userid )}
  end



  @impl true
  def handle_event("cancel-reply", _ , socket) do
    {:noreply, assign(socket, replymsg: [])}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    {:noreply, socket}
  end
end
