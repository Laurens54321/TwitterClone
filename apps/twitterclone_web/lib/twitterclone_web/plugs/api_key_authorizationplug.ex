defmodule TwittercloneWeb.Plugs.ApiKeyAuthorizationPlug do
  import Plug.Conn
  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.ApiKey
  require Logger



  def init(opts), do: opts

  def call(conn, _params) do
    key = conn
      |> get_req_header("x-api-key")
      |> get_key()

    with %ApiKey{user_id: user_id} <- UserContext.api_key_exists(%{key: key}) do
      {:ok, user} = UserContext.get_by_userid(user_id)
      Logger.debug "User key: #{user.user_id}"
      assign(conn, :current_api_user, user)
    else
      _ -> conn
            |> send_resp(:unauthorized, "Invalid or no API key ")
            |> halt()
    end
  end

  defp get_key([]), do: nil
  defp get_key([key]), do: key
end
