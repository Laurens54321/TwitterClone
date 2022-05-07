defmodule TwittercloneWeb.Plugs.Protection do
  import Plug.Conn
  import Phoenix.Controller


  alias Twitterclone.UserContext.User

  @privileged_roles ["Admin", "Manager"]



  def init(default), do: default

  def call(conn = %{method: "PATCH"}, _args) do
    control_user conn
  end

  def call(conn = %{method: "DELETE"}, _args) do
    control_user conn
  end

  def call(conn, _args), do: conn

  defp control_user(conn = %{guardian_default_resource: %User{}}), do: control_element conn
  defp control_user(conn), do: grant_access(conn, false)

  defp control_element(%{private: %{guardian_default_resource: %User{} = current_user}, path_info: ["users", user_id]} = conn) do
    if user_id == current_user.user_id, do: conn
    grant_access(conn, current_user.role in @privileged_roles)
  end

  defp control_element(%{private: %{guardian_default_resource: %User{} = current_user}, path_info: ["twats", twat_id]} = conn) do
    user_id = Twitterclone.TwatContext.get_by_userid(twat_id).user_id
    if user_id == current_user.user_id, do: conn
    grant_access(conn, current_user.role in @privileged_roles)
  end

  defp control_element(conn), do: conn

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> redirect(to: "/unauthorized")
    |> halt
  end

end
