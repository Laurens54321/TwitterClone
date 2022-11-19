defmodule UserSearchResultComponent do
  use TwittercloneWeb, :live_component

  alias Twitterclone.UserContext.User
  alias Twitterclone.TwatContext.Twat

  def isreply(msg) do
    msg.replyto_id != nil
  end

  def render(%{item: %User{}} = assigns) do
    ~H"""
      <div class="hover:bg-dark p-5 m-2 rounded-xl flex flex-row" phx-click="select-user" phx-value-user={@item.user_id} >
          <div class="mr-3">
              <img src={@item.picture_url} alt="Profile" class="rounded-xl" style="width:40px;height:40px;">
          </div>
          <div class="flex flex-col justify-center">
              <p>@<%= @item.user_id %></p>
          </div>
      </div>
    """
  end

  def render(%{item: %Twat{}} = assigns) do
    ~H"""
      <div class="hover:bg-dark p-5 m-2 rounded-xl flex flex-row" phx-click="select-twat" phx-value-twat={@item.id} >
          <div class="mr-3 flex flex-col justify-center">
              <img src={@item.user.picture_url} alt="Profile" class="rounded-xl" style="width:40px;height:40px;">
          </div>
          <div class="flex flex-col justify-center">
              <div class="flex flex-row" >
                <p class="text-sm text-darktextclr" ><%= @item.user.user_id %> • <%= @item.inserted_at |> TwittercloneWeb.format_timestamp %></p>
              </div>
              <p><%= @item.text %></p>
          </div>
      </div>
    """
  end
end
