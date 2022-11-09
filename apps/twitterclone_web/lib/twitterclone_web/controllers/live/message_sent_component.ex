defmodule MessageComponent do
  use TwittercloneWeb, :live_component
  use Phoenix.LiveComponent

  def isreply(msg) do
    msg.replyto_id != nil
  end

  def render(%{msgtype: :sent} = assigns) do

    ~H"""
        <div class="flex flex-row-reverse group" >
            <div class="flex flex-col " >
                <!-- reply showcase -->
                <%= if (MessageComponent.isreply(@message)) do %>
                    <div class="flex flex-row-reverse ">
                        <%= if @message.replyto.user_id == @current_user do  %>
                            <div class="mr-6 bg-green-700 opacity-50 rounded-lg p-1 px-2 flex-shrink" onclick={"gotomsg(#{@message.replyto.id})"} >
                                <p class="text-base text-white truncate max-w-md" > <%= @message.replyto.text %> </p>
                            </div>
                        <% else %>
                            <div class="mx-6 bg-blue-700 opacity-50 rounded-lg p-1 px-2 flex-shrink" onclick={"gotomsg(#{@message.replyto.id})"} >
                                <p class="text-base text-white truncate max-w-md" > <%= @message.replyto.text %> </p>
                            </div>
                        <% end %>
                    </div>
                <% end %>
                <div class="flex flex-col">
                    <div class="flex flex-row-reverse">
                        <!-- actual message -->
                        <div class=" m-1 py-2 px-5 rounded-lg group-hover:bg-green-800 bg-green-600  w-fit" phx-click="click-message" phx-value-id={@message.id} phx-value-message={@message.text} phx-value-userid={@message.user_id}>
                            <p class="text-sm text-right"><%= @message.user_id %> </p>
                            <p><%= @message.text %></p>
                        </div>
                        <!-- Onhover button -->
                        <div class="hidden group-hover:flex items-center ">
                            <svg aria-hidden="true" class="block w-7 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="white">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                            </svg>
                        </div>
                    </div>
                    <!-- time -->
                    <%= if (@showtime) do %>
                        <p class="text-sm text-darktextclr text-right"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
                    <% else %>
                        <p class="hidden group-hover:block text-sm text-darktextclr text-right"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
                    <% end %>
                </div>
            </div>
        </div>

    """
  end

  def render(%{msgtype: :rec} = assigns) do

    ~H"""
    <div class="group" >
        <div class="flex flex-col">
        <!-- reply showcase -->
            <%= if (MessageComponent.isreply(@message)) do %>
                <div class="flex flex-row ">
                    <%= if @message.replyto.user_id == @current_user do  %>
                        <div class="mx-6 bg-green-700 opacity-50 rounded-lg p-1 px-2 flex-shrink" onclick={"gotomsg(#{@message.replyto.id})"} >
                            <p class="text-base text-white truncate max-w-md" > <%= @message.replyto.text %> </p>
                        </div>
                    <% else %>
                        <div class="mx-6 bg-blue-700 opacity-50 rounded-lg p-1 px-2 flex-shrink" onclick={"gotomsg(#{@message.replyto.id})"}>
                            <p class="text-base text-white truncate max-w-md" > <%= @message.replyto.text %> </p>
                        </div>
                    <% end %>
                </div>
            <% end %>
            <div class="flex flex-row " phx-click="click-message" phx-value-id={@message.id} phx-value-message={@message.text} phx-value-userid={@message.user_id}>
                <!-- actual message -->
                <div class="m-1 py-2 px-5 rounded-lg bg-blue-600 group-hover:bg-blue-800 w-fit">
                    <p class="text-sm text-left"><%= @message.user_id %> </p>
                    <p><%= @message.text %></p>
                </div>
                <!-- Onhover button -->
                <div class="flex items-center">
                    <svg aria-hidden="true" class="hidden group-hover:block w-7 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="white">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                    </svg>
                </div>
            </div>
            <!-- time -->
            <%= if (@showtime) do %>
                <p class="hidden group-hover:block text-sm text-darktextclr"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
            <% else %>
                <p class="text-sm text-darktextclr"> <%= @message.inserted_at |> Timex.format!("%H:%M", :strftime) %> </p>
            <% end %>
        </div>
    </div>


    """
  end
end
