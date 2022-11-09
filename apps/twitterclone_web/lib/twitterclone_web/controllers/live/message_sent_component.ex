defmodule MessageComponent do
  use TwittercloneWeb, :live_component
  use Phoenix.LiveComponent


  def render(%{msgtype: :sent} = assigns) do

    ~H"""
    <div class="flex flex-row-reverse group" >
    <div class="flex flex-col">
        <div class="m-1 py-2 px-5 rounded-lg bg-green-600 w-fit">
            <p class="text-sm text-right"><%= @message.user_id %> </p>
            <p><%= @message.text %></p>
        </div>
        <p class="hidden group-hover:block text-sm text-darktextclr text-right"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
    </div>


    <div class="flex items-center">
        <svg aria-hidden="true" class="hidden group-hover:block w-7 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="white">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
        </svg>
    </div>


    </div>

    """
  end

  def render(%{msgtype: :rec} = assigns) do

    ~H"""
    <div class="group" >
    <div class="flex flex-row " phx-click="click-message" phx-value-id={@message.id}>
        <div class="m-1 py-2 px-5 rounded-lg bg-blue-600 group-hover:bg-blue-800 w-fit">
            <p class="text-sm text-left"><%= @message.user_id %> </p>
            <p><%= @message.text %></p>
        </div>
        <div class="flex items-center">
            <svg aria-hidden="true" class="hidden group-hover:block w-7 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="white">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
            </svg>
        </div>
    </div>
    <p class="hidden group-hover:block text-sm text-darktextclr"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
    </div>


    """
  end
end
