defmodule Twitterclone.CommentContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.CommentContext

  describe "comments" do
    alias Twitterclone.CommentContext.Comment

    import Twitterclone.CommentContextFixtures
    import Twitterclone.TwatContextFixtures

    @invalid_attrs %{text: nil, user_id: nil, twat_id: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert CommentContext.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert CommentContext.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with same user_id & valid data creates a comment" do
      twat = twat_fixture()
      valid_attrs = %{text: "some text", user_id: twat.user_id, twat_id: twat.id}

      assert {:ok, %Comment{} = comment} = CommentContext.create_comment(valid_attrs)
      assert comment.text == "some text"
      assert comment.user_id == twat.user_id
      assert comment.twat_id == twat.id
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommentContext.create_comment(@invalid_attrs)
    end

    test "create_comment/1 with non existent users returns error changeset" do
      attrs = %{user_id: "non existent user", follower_id: "another non existing user"}
      assert {:error, %Ecto.Changeset{}} = CommentContext.create_comment(attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Comment{} = comment} = CommentContext.update_comment(comment, update_attrs)
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
