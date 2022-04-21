defmodule Twitterclone.TwatContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitterclone.TwatContext` context.
  """

  @doc """
  Generate a twat.
  """
  import Twitterclone.UserContextFixtures
  def twat_fixture(user_id, attrs \\ %{}) do
    {:ok, twat} =
      attrs
      |> Enum.into(%{
        text: "some text",
        user_id: user_id
      })
      |> Twitterclone.TwatContext.create_twat()

    twat
  end

  def twat_fixture() do
    user = user_fixture()
    twat_fixture(user.user_id)
  end

end
