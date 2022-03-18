defmodule Twitterclone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Twitterclone.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Twitterclone.PubSub}
      # Start a worker by calling: Twitterclone.Worker.start_link(arg)
      # {Twitterclone.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Twitterclone.Supervisor)
  end
end
