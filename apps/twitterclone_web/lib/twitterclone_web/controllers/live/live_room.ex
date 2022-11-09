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
    #RoomContext.remove_newmsg(room_id, user.user_id)
    TwittercloneWeb.Presence.track(self(), topic, user.user_id, %{})
    {:ok, assign(socket,
            room: room,
            topic: topic,
            messageForm: "",
            messages: room.messages,
            user: user.user_id,
            replymsg: []
            )}

  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    user_id = socket.assigns.user
    room_id = socket.assigns.room.id
    {:ok, newmsg} = RoomContext.create_message(user_id, room_id, message)
    TwittercloneWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", newmsg)
    {:noreply, assign(socket, messageForm: "")}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, messageForm: message)}
  end

  defp samereply([], id) do
    false
  end

  defp samereply(replymsg, id) do
    replymsg.id == id
  end

  @impl true
  def handle_event("click-message", %{"id" => id}, socket) do
    if (samereply(socket.assigns.replymsg, id)), do: {:noreply, socket} # this line doesnt work
    {:ok, msg} = RoomContext.get_message(id)
    {:noreply, assign(socket, replymsg: msg)}
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
