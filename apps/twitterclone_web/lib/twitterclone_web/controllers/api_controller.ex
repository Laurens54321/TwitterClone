defmodule TwittercloneWeb.APIController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext

  def generate(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    case UserContext.gen_api_key(user) do
      {:ok, _api_key} ->
        conn
        |> put_flash(:info, "Your API key was generated")
        |> redirect(to: Routes.profile_path(conn, :myprofile))
      {:error, _} ->
        conn
        |> put_flash(:error, "There was an problem generating the API key")
        |> redirect(to: Routes.profile_path(conn, :myprofile))
    end
  end
end
