defmodule TwittercloneWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """

  use TwittercloneWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_flash(:info, "Changeset error")
    |> render("index.html", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> redirect(to: Routes.page_path(conn, :error, 404, "Item not Found"))
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> redirect(to: Routes.page_path(conn, :unauthorized))
  end


end
