defmodule TwittercloneWeb.TwatController do
  use TwittercloneWeb, :controller

  alias Twitterclone.TwatContext
  alias Twitterclone.TwatContext.Twat

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    twats = TwatContext.list_twats()
    render(conn, "index.json", twats: twats)
  end

  def create(conn, %{"twat" => twat_params}) do
    with {:ok, %Twat{} = twat} <- TwatContext.create_twat(twat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.twat_path(conn, :show, twat))
      |> render("show.json", twat: twat)
    end
  end

  def show(conn, %{"id" => id}) do
    twat = TwatContext.get_twat!(id)
    render(conn, "show.json", twat: twat)
  end

  def update(conn, %{"id" => id, "twat" => twat_params}) do
    twat = TwatContext.get_twat!(id)

    with {:ok, %Twat{} = twat} <- TwatContext.update_twat(twat, twat_params) do
      render(conn, "show.json", twat: twat)
    end
  end

  def delete(conn, %{"id" => id}) do
    twat = TwatContext.get_twat!(id)

    with {:ok, %Twat{}} <- TwatContext.delete_twat(twat) do
      send_resp(conn, :no_content, "")
    end
  end
end
