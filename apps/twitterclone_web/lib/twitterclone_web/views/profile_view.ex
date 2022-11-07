defmodule TwittercloneWeb.ProfileView do
  use TwittercloneWeb, :view

  def api_key(%{api_key: %{key: key}}), do: key
  def api_key(%{api_key: nil}), do: "No API key generated"

  def getMessageCount(room) do
    Enum.count(room.messages)
  end

end
