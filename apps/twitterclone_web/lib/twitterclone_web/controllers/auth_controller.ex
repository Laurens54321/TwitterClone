defmodule TwittercloneWeb.AuthController do
  use TwittercloneWeb, :controller
  require Logger

  alias Twitterclone.UserContext.OauthUser

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}
    changeset = OauthUser.changeset(%OauthUser{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
      case insert_or_update_user(changeset) do
          {:ok, user} ->
              conn
              |> put_flash(:info, "Welcome back")
              |> put_session(:user_id, user.id)
              |> redirect(to: Routes.page_path(conn, :index))
          {:error, _reason} ->
              conn
              |> put_flash(:error, "error signing in")
              |> redirect(to: Routes.page_path(conn, :index))
      end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(OauthUser, email: changeset.changes.email) do
        nil ->
          Repo.insert(changeset)
        user ->
          {:ok, user}
        end
  end
end
