defmodule TwittercloneWeb.GoogleAuthController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserContext

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    case get_oauth profile do
      {:ok, oauth_user} ->
        conn
        |> put_session(:sub_token, oauth_user.sub_token)
        |> redirect(to: Routes.session_path(conn, :login_sub))
      {:new, oauth_user} ->
        conn
        |> put_session(:sub_token, oauth_user.sub_token)
        |> redirect(to: "/live/username_picker")
    end

  end

  defp get_oauth(%{email: email, name: name, picture: picture_url, sub: sub_token}) do
    case UserContext.get_oauth_user_bysub(sub_token, [:user]) do
      {:ok, oauthuser} -> {:ok, oauthuser}
      {:error, :not_found} -> {:ok, newoauth} = UserContext.create_oauth_user(%{
        sub_token: sub_token,
        domain: "google.com",
        email: email,
        name: name,
        picture_url: picture_url})
        {:new, newoauth}
    end
  end
end
