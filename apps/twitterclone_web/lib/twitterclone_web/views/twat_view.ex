defmodule TwittercloneWeb.TwatView do
  use TwittercloneWeb, :view


  def render("index.json", %{twats: twats}) do
    %{data: render_many(twats, TwatView, "twat.json")}
  end

  def render("show.json", %{twat: twat}) do
    %{data: render_one(twat, TwatView, "twat.json")}
  end

  def render("twat.json", %{twat: twat}) do
    %{
      id: twat.id,
      text: twat.text,
      creationDate: twat.creationDate
    }
  end
end
