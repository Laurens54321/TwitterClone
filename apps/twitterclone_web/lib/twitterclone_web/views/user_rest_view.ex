defmodule TwittercloneWeb.UserRestView do
  use TwittercloneWeb, :view
  alias TwittercloneWeb.UserRestView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserRestView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserRestView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user_id: user.user_id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  end

end
