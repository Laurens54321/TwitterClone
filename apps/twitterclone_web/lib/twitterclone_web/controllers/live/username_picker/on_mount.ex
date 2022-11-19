defmodule TwittercloneWeb.OnMount do
  import Phoenix.LiveView

  def on_mount(:default, _params, %{"sub_token" => sub_token} = _session, socket) do
    {:cont, Phoenix.LiveView.assign(socket, sub_token: sub_token)}

    # socket = assign_new(socket, :current_user, fn ->
    #   Accounts.get_user!(user_id)
    # end)

    # if socket.assigns.current_user.confirmed_at do
    #   {:cont, socket}
    # else
    #   {:halt, redirect(socket, to: "/login")}
    # end
  end
end
