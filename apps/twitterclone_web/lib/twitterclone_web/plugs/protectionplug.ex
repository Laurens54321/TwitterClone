defmodule TwittercloneWeb.Plugs.Protection do
  import Plug.Conn
  import Phoenix.Controller


  alias Twitterclone.UserContext.User
  alias Twitterclone.TwatContext.Twat
  import Logger

  @privileged_roles ["Admin", "Manager"]



  def init(default), do: default

  def call(conn = %{method: "PATCH"}, _args) do
    control_user conn
  end

  def call(conn = %{method: "DELETE"}, _args) do
    control_user conn
  end

  def call(conn, _args), do: conn

  defp control_user(conn = %{private: %{guardian_default_resource: %User{}}}), do: control_element conn
  defp control_user(conn), do: grant_access(conn, false)

  defp control_element(%{private: %{guardian_default_resource: %User{} = current_user}, path_info: ["users", user_id]} = conn) do
    if user_id == current_user.user_id, do: conn
    grant_access(conn, current_user.role in @privileged_roles)
  end

  defp control_element(%{private: %{guardian_default_resource: %User{} = current_user}, path_info: ["twats", twat_id]} = conn) do
    with {:ok, %Twat{} = twat} <- Twitterclone.TwatContext.get_twat(twat_id) do
        if twat.user_id == current_user.user_id, do: conn
        grant_access(conn, current_user.role in @privileged_roles)
    end
  end

  defp control_element(conn) do
    debug "DEFAULT CONTROL ELEMENT"
    conn
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> redirect(to: "/unauthorized")
    |> halt
  end

end
