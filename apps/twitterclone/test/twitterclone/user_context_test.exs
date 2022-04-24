defmodule Twitterclone.UserContextTest do
  use Twitterclone.DataCase

  alias Twitterclone.UserContext

  describe "users" do
    alias Twitterclone.UserContext.User

    import Twitterclone.UserContextFixtures

    @invalid_attrs %{email: nil, name: nil, passwordHash: nil, user_id: nil}
    @valid_attrs %{
      user_id: Twitterclone.random_string_gen(8),
      name: "some name",
      email: Twitterclone.random_string_gen(8) <> "@gmail.com",
      password: "some password",
      role: "User"
    }

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert hd(UserContext.list_users()).user_id == user.user_id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.user_id).user_id == user.user_id
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = @valid_attrs

      assert {:ok, %User{} = user} = UserContext.create_user(valid_attrs)
      assert user.email == valid_attrs.email
      assert user.name == valid_attrs.name
      assert user.user_id == valid_attrs.user_id
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "updatedemail@gmail.com", name: "some updated name", password: "some updated passwordHash", user_id: "some updated user_id"}

      assert {:ok, %User{} = user} = UserContext.update_user(user, update_attrs)
      assert user.email == "updatedemail@gmail.com"
      assert user.name == "some updated name"
      assert user.user_id == "some updated user_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user.user_id == UserContext.get_user!(user.user_id).user_id
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.user_id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end

    test "create_user/1 with duplicate user_id returns error" do
      valid_attrs = %{email: "updatedemail@gmail.com", name: "some name", password: "some passwordHash", user_id: "same_user_id"}
      valid_attrs_ = %{email: "updatedemail@gmail.com_", name: "some name", password: "some passwordHash", user_id: "same_user_id"}

      assert {:ok, %User{}} = UserContext.create_user(valid_attrs)
      assert_raise Ecto.ConstraintError, fn -> UserContext.create_user(valid_attrs_) end
    end

    test "create_user/1 with duplicate email returns error" do
      valid_attrs = %{email: "sameemail@gmail.com", name: "some name", password: "some passwordHash", user_id: "some_user_id"}
      valid_attrs_ = %{email: "sameemail@gmail.com", name: "some name", password: "some passwordHash", user_id: "somedifferent_user_id"}

      assert {:ok, %User{}} = UserContext.create_user(valid_attrs)
      assert_raise Ecto.ConstraintError, fn -> UserContext.create_user(valid_attrs_) end
    end

  end




  describe "followers" do
    alias Twitterclone.UserContext.Follower

    import Twitterclone.UserContextFixtures

    @invalid_attrs %{follower_id: nil, user_id: nil}

    test "list_followers/0 returns all followers" do
      follower = follower_fixture()
      assert UserContext.list_followers() == [follower]
    end

    test "get_follower!/1 returns the follower with given id" do
      follower = follower_fixture()
      assert UserContext.get_follower!(follower.id) == follower
    end

    test "create_follower/1 with valid data creates a follower" do
      user1 = user_fixture()
      user2 = user_fixture()
      valid_attrs = %{follower_id: user1.user_id, user_id: user2.user_id}
      assert {:ok, %Follower{} = follower} = UserContext.create_follower(valid_attrs)
      assert follower.follower_id == user1.user_id
      assert follower.user_id == user2.user_id
    end

    test "create_follower/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_follower(@invalid_attrs)
    end

    test "delete_follower/1 deletes the follower" do
      follower = follower_fixture()
      assert {:ok, %Follower{}} = UserContext.delete_follower(follower)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_follower!(follower.id) end
    end

    test "change_follower/1 returns a follower changeset" do
      follower = follower_fixture()
      assert %Ecto.Changeset{} = UserContext.change_follower(follower)
    end
  end
end
