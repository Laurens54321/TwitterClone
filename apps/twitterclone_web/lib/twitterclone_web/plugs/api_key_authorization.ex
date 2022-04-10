defmodule TwittercloneWeb.Plugs.ApiKeyAuthorization do
  import Plug.Conn
  alias Twitterclone.UserContext

  def init(_args) do
  end

  def call(conn, _args) do
    key = conn
      |> get_req_header("api-key")
      |> parse_key()

    if UserContext.api_key_exists?(key) do
      conn
    else
      conn
        |> send_resp(:unauthorized, "Invalid API key")
        |> halt()
    end
  end

  defp parse_key([]), do: nil
  defp parse_key([key]), do: key
end
