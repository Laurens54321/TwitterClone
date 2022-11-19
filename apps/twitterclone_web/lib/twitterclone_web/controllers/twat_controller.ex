defmodule TwittercloneWeb.TwatController do
  use TwittercloneWeb, :controller

  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    twats = TwatContext.list_twats([:user, :comments])
    render(conn, "index.html", twats: twats)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, twat} <- TwatContext.get_twat(id, [:user, :comments, comments: [:user]]) do
      changeset = TwatContext.change_twat(%Twat{})
      render(conn, "twatpage.html", twat: twat, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, %Twat{} = twat} <- TwatContext.get_twat(id) do
      changeset = TwatContext.change_twat(twat)
      render(conn, "edit.html", changeset: changeset, twat: twat)
    end
  end

  def update(conn, %{"id" => id, "twat" => twat_params}) do
    with {:ok, %Twat{} = twat} <- TwatContext.get_twat(id) do
      case TwatContext.update_twat(twat, twat_params) do
        {:ok, twat} ->
          conn
          |> put_flash(:info, "Twat updated successfully.")
          |> redirect(to: Routes.twat_path(conn, :show, twat))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", twat: twat, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Twat{} = twat} <- TwatContext.get_twat(id) do
      with {:ok, %Twat{}} <- TwatContext.delete_twat(twat) do
        redirect(conn, to: NavigationHistory.last_path(conn))
      end
    end
  end
end
