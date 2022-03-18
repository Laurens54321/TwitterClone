defmodule Twitterclone.CommentContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitterclone.CommentContext` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment_id: "some comment_id",
        creationDate: ~D[2022-03-17],
        text: "some text"
      })
      |> Twitterclone.CommentContext.create_comment()

    comment
  end
end
