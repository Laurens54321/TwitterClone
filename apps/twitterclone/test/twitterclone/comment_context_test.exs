defmodule Twitterclone.CommentContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.CommentContext

  describe "comments" do
    alias Twitterclone.CommentContext.Comment

    import Twitterclone.CommentContextFixtures

    @invalid_attrs %{comment_id: nil, creationDate: nil, text: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert CommentContext.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert CommentContext.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{comment_id: "some comment_id", creationDate: ~D[2022-03-17], text: "some text"}

      assert {:ok, %Comment{} = comment} = CommentContext.create_comment(valid_attrs)
      assert comment.comment_id == "some comment_id"
      assert comment.creationDate == ~D[2022-03-17]
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommentContext.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{comment_id: "some updated comment_id", creationDate: ~D[2022-03-18], text: "some updated text"}

      assert {:ok, %Comment{} = comment} = CommentContext.update_comment(comment, update_attrs)
      assert comment.comment_id == "some updated comment_id"
      assert comment.creationDate == ~D[2022-03-18]
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = CommentContext.update_comment(comment, @invalid_attrs)
      assert comment == CommentContext.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = CommentContext.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> CommentContext.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = CommentContext.change_comment(comment)
    end
  end
end
