defmodule TwittercloneWeb.LiveUsernamePicker do
  use TwittercloneWeb, :live_view
  on_mount TwittercloneWeb.OnMount
  require Logger

  alias Twitterclone.UserContext

  @impl true
  def mount(params, session, socket) do
    {:ok, assign(socket, usernameForm: "", sub_token: socket.assigns.sub_token, error: [], message: [])}
  end

  defp get_user(socket, message) do
    case UserContext.get_by_userid(message) do
      {:ok, _user} -> {:noreply, assign(socket, usernameForm: message, error: "Username already taken", message: [])}
      {:error, :not_found} -> {:noreply, assign(socket, usernameForm: message, message: "Username available!", error: [])}
    end
  end

  @impl true
  def handle_event("form_update", %{"username" => %{"message" => message}}, socket) do
    newsocket = TwittercloneWeb.handle_blazeit(socket, message)
    if (String.length(message) <= 2) do
      {:noreply, assign(newsocket, usernameForm: message, error: "Username too short", message: [])}
    else
      get_user(newsocket, message)
    end
  end

  @impl true
  def handle_event("submit_username", %{"username" => %{"message" => username}}, socket) do
    {:ok, oauthuser} = UserContext.get_oauth_user_bysub(socket.assigns.sub_token)
    {:ok, _user} = UserContext.create_user(%{
      user_id: username,
      name: oauthuser.name,
      email: oauthuser.email,
      password: socket.assigns.sub_token,
      picture_url: oauthuser.picture_url
    })
    UserContext.update_oauthUser(oauthuser, %{user_id: username})
    {:noreply, redirect(socket, to: Routes.session_path(socket, :login_sub))}
  end

end
