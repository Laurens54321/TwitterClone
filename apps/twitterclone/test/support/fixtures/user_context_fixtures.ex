defmodule Twitterclone.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitterclone.UserContext` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        passwordHash: "some passwordHash",
        user_id: "some user_id"
      })
      |> Twitterclone.UserContext.create_user()

    user
  end
end
