defmodule TwittercloneWeb.SessionController do
  use TwittercloneWeb, :controller

  alias TwittercloneWeb.Guardian
  alias Twitterclone.UserContext
  alias Twitterclone.UserContext.User

  def new(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: Routes.profile_path(conn, :feed))
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login), oauth_google_url: ElixirAuthGoogle.generate_oauth_url(conn))
    end
  end

  def login_sub(%{private:  %{:plug_session => %{"sub_token" => sub_token}}} = conn, _args) do
    UserContext.authenticate_user_sub(sub_token)
    |> login_reply(conn)
  end

  def login(conn, %{"user" => %{"user_id" => user_id, "password" => password}}) do
    UserContext.authenticate_user(user_id, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: Routes.profile_path(conn, :feed))
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp login_reply({:create, :not_found}, conn) do
    conn
    |> put_flash(:info, "Choose a username to continue")
    |> redirect(to: "/live/username_picker")
  end
end
