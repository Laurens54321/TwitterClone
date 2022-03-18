defmodule Twitterclone.UserContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.UserContext

  describe "users" do
    alias Twitterclone.UserContext.User

    import Twitterclone.UserContextFixtures

    @invalid_attrs %{email: nil, name: nil, passwordHash: nil, user_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", name: "some name", passwordHash: "some passwordHash", user_id: "some user_id"}

      assert {:ok, %User{} = user} = UserContext.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.passwordHash == "some passwordHash"
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name", passwordHash: "some updated passwordHash", user_id: "some updated user_id"}

      assert {:ok, %User{} = user} = UserContext.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.passwordHash == "some updated passwordHash"
      assert user.user_id == "some updated user_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
