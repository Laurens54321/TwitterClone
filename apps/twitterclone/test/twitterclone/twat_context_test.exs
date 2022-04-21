defmodule Twitterclone.TwatContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.TwatContext

  describe "twats" do
    alias Twitterclone.TwatContext.Twat

    import Twitterclone.TwatContextFixtures
    import Twitterclone.UserContextFixtures

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
      user = user_fixture()
      valid_attrs = %{text: "some text", user_id: user.user_id}

      assert {:ok, %Twat{} = twat} = TwatContext.create_twat(valid_attrs)
      assert twat.text == "some text"
    end

    test "create_twat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TwatContext.create_twat(@invalid_attrs)
    end

    test "update_twat/2 with valid data updates the twat" do
      twat = twat_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Twat{} = twat} = TwatContext.update_twat(twat, update_attrs)
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
end
