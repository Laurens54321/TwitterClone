defmodule TwittercloneWeb.TwatAPIView do
  use TwittercloneWeb, :view
  alias TwittercloneWeb.TwatAPIView

  def render("index.json", %{twats: twats}) do
   render_many(twats, TwatAPIView, "twat.json", as: :twat)
  end

  def render("show.json", %{twat: twat}) do
    render_one(twat, TwatAPIView, "twat.json", as: :twat)
  end

  def render("twat.json", %{twat: twat}) do
    %{
      id: twat.id,
      user: twat.user_id,
      text: twat.text,
      creationDate: twat.inserted_at
    }
  end
end
