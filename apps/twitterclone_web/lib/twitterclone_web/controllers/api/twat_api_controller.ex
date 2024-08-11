defmodule TwittercloneWeb.TwatAPIController do
  use TwittercloneWeb, :controller

  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  action_fallback TwittercloneWeb.APIFallbackController

  def index(conn, _params) do
    twats = TwatContext.list_twats()
    render(conn, "index.json", twats: twats)
  end

  def create(conn, %{"twat" => twat_params}) do
    if twat_params["user_id"] == conn.assigns.current_api_user.user_id do
      with {:ok, %Twat{} = twat} <- TwatContext.create_twat(twat_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.twat_path(conn, :show, twat))
        |> render("show.json", twat: twat)
      end
    else
      {:error, :unauthorized}
    end

  end

  def show(conn, %{"id" => id}) do
    twat = TwatContext.get_twat!(id)
    render(conn, "show.json", twat: twat)
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Twat{} = twat} <- TwatContext.get_twat(id) do
      if twat.user_id == conn.assigns.current_api_user.user_id, do: {:error, :unauthorized}
      with {:ok, %Twat{}} <- TwatContext.delete_twat(twat) do
        send_resp(conn, 202, "")
      end
    end

  end
end
