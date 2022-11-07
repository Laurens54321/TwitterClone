defmodule TwittercloneWeb.LiveRoom do
  use TwittercloneWeb, :live_view
  require Logger

  alias Twitterclone.RoomContext
  alias Twitterclone.RoomContext.Message

  @impl true
  def mount(%{"room_id" => room_id}, session, socket) do
    {:ok, user, _idk} = Guardian.resource_from_token(TwittercloneWeb.Guardian, session["guardian_default_token"])
    {:ok, room} = RoomContext.get_room(room_id, [:messages])
    topic = "room" <> room_id
    if connected?(socket), do: TwittercloneWeb.Endpoint.subscribe(topic)
    #RoomContext.remove_newmsg(room_id, user.user_id)
    TwittercloneWeb.Presence.track(self(), topic, user.user_id, %{})
    {:ok, assign(socket,
            room: room,
            topic: topic,
            messageForm: "",
            messages: room.messages,
            user: user.user_id
            )}

  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    user_id = socket.assigns.user
    room_id = socket.assigns.room.id
    {:ok, newmsg} = RoomContext.create_message(user_id, room_id, message)
    #RoomContext.add_newmsg(room_id, user_id)

    TwittercloneWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", newmsg)
    {:noreply, assign(socket, messageForm: "")}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, messageForm: message)}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    Logger.info "new-msg"
    {:noreply, assign(socket, messages: [message])}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    {:noreply, socket}
  end
end
