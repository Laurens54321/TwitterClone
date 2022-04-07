defmodule Twitterclone.TwatContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitterclone.TwatContext` context.
  """

  @doc """
  Generate a twat.
  """
  def twat_fixture(attrs \\ %{}) do
    {:ok, twat} =
      attrs
      |> Enum.into(%{
        creationDate: ~D[2022-03-17],
        text: "some text"
      })
      |> Twitterclone.TwatContext.create_twat()

    twat
  end

end
