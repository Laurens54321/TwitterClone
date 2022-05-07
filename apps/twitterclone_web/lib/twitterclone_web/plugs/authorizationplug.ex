defmodule TwittercloneWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  alias Twitterclone.UserContext.User
  alias Twitterclone.TwatContext.Twat
  alias Phoenix.Controller

  def init(options), do: options

  def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
    grant_access(conn, u.role in roles, "/", "Unauthorized Access")
  end

  def call(conn, _), do: grant_access(conn, false, "/login", "Not Logged In") # user not found so no authorization

  def grant_access(conn, true, _, _), do: conn  # role is in accepted roles

  def grant_access(conn, false, redirect, msg) do        # role is not in accepted roles
    conn
    |> Controller.put_flash(:error, msg)
    |> Controller.redirect(to: redirect)
    |> halt
  end
end
