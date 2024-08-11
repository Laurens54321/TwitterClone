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
        user_id: Twitterclone.random_string_gen(8),
        name: "some name",
        email: Twitterclone.random_string_gen(8) <> "@gmail.com",
        password: "some password",
        role: "User"
      })
      |> Twitterclone.UserContext.create_user()
    Twitterclone.UserContext.gen_api_key(user)

    user
  end

  @doc """
  Generate a follower.
  """
  def follower_fixture(attrs \\ %{}) do
    user1 = user_fixture()
    user2 = user_fixture()

    {:ok, follower} =
      attrs
      |> Enum.into(%{
        follower_id: user1.user_id,
        user_id: user2.user_id
      })
      |> Twitterclone.UserContext.create_follower()

    follower
  end
end
