defmodule TwittercloneWeb.Plugs.ApiKeyAuthorizationPlug do
  import Plug.Conn
  alias Twitterclone.UserContext

  def init(opts), do: opts

  def call(conn, _params) do
    key = conn
      |> get_req_header("api-key-twatter")
      |> get_key()

    if UserContext.api_key_exists?(key) do
      conn
    else
      conn
        |> send_resp(:unauthorized, "Invalid API key")
        |> halt()
    end
  end

  defp get_key([]), do: nil
  defp get_key([key]), do: key
end
