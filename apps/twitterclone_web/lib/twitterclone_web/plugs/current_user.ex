defmodule TwittercloneWeb.Plugs.CurrentUserPlug do
  import Plug.Conn
  import Logger

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    msg = if current_user == nil do
      "Current User: Not Logged In"
    else
      "Current User: #{current_user.user_id}, #{current_user.role}"
    end
    Logger.debug msg
    assign(conn, :current_user, current_user)
  end
end
