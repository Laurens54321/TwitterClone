defmodule Twitterclone.CommentContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitterclone.CommentContext` context.
  """

  @doc """
  Generate a comment.
  """
  import Twitterclone.TwatContextFixtures
  def comment_fixture(user_id, twat_id) do
    {:ok, comment} =
      _attrs = %{}
      |> Enum.into(%{
        text: "some text",
        user_id: user_id,
        twat_id: twat_id
      })
      |> Twitterclone.CommentContext.create_comment()

    comment
  end

  def comment_fixture() do
    twat = twat_fixture()
    comment_fixture(twat.user_id, twat.id)
  end

end
