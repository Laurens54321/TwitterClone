defmodule TwittercloneWeb.Plugs.CurrentUserPlug do
  import Plug.Conn

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
