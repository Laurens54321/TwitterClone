defmodule Twitterclone.TwatContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.TwatContext

  describe "twats" do
    alias Twitterclone.TwatContext.Twat

    import Twitterclone.TwatContextFixtures

    @invalid_attrs %{creationDate: nil, text: nil}

    test "list_twats/0 returns all twats" do
      twat = twat_fixture()
      assert TwatContext.list_twats() == [twat]
    end

    test "get_twat!/1 returns the twat with given id" do
      twat = twat_fixture()
      assert TwatContext.get_twat!(twat.id) == twat
    end

    test "create_twat/1 with valid data creates a twat" do
      valid_attrs = %{creationDate: ~D[2022-03-17], text: "some text"}

      assert {:ok, %Twat{} = twat} = TwatContext.create_twat(valid_attrs)
      assert twat.creationDate == ~D[2022-03-17]
      assert twat.text == "some text"
    end

    test "create_twat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TwatContext.create_twat(@invalid_attrs)
    end

    test "update_twat/2 with valid data updates the twat" do
      twat = twat_fixture()
      update_attrs = %{creationDate: ~D[2022-03-18], text: "some updated text"}

      assert {:ok, %Twat{} = twat} = TwatContext.update_twat(twat, update_attrs)
      assert twat.creationDate == ~D[2022-03-18]
      assert twat.text == "some updated text"
    end

    test "update_twat/2 with invalid data returns error changeset" do
      twat = twat_fixture()
      assert {:error, %Ecto.Changeset{}} = TwatContext.update_twat(twat, @invalid_attrs)
      assert twat == TwatContext.get_twat!(twat.id)
    end

    test "delete_twat/1 deletes the twat" do
      twat = twat_fixture()
      assert {:ok, %Twat{}} = TwatContext.delete_twat(twat)
      assert_raise Ecto.NoResultsError, fn -> TwatContext.get_twat!(twat.id) end
    end

    test "change_twat/1 returns a twat changeset" do
      twat = twat_fixture()
      assert %Ecto.Changeset{} = TwatContext.change_twat(twat)
    end
  end

  describe "comments" do
    alias Twitterclone.TwatContext.Comment

    import Twitterclone.TwatContextFixtures

    @invalid_attrs %{comment_id: nil, creationDate: nil, text: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert TwatContext.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert TwatContext.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{comment_id: "some comment_id", creationDate: ~D[2022-03-17], text: "some text"}

      assert {:ok, %Comment{} = comment} = TwatContext.create_comment(valid_attrs)
      assert comment.comment_id == "some comment_id"
      assert comment.creationDate == ~D[2022-03-17]
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TwatContext.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{comment_id: "some updated comment_id", creationDate: ~D[2022-03-18], text: "some updated text"}

      assert {:ok, %Comment{} = comment} = TwatContext.update_comment(comment, update_attrs)
      assert comment.comment_id == "some updated comment_id"
      assert comment.creationDate == ~D[2022-03-18]
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = TwatContext.update_comment(comment, @invalid_attrs)
      assert comment == TwatContext.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = TwatContext.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> TwatContext.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = TwatContext.change_comment(comment)
    end
  end
end
