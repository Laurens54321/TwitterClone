defmodule TwittercloneWeb.UserControllerTest do
  use TwittercloneWeb.ConnCase

  import Twitterclone.UserContextFixtures
  alias Twitterclone.UserContext.User

  @create_attrs %{email: "some@email.com", name: "some name", password: "some password", user_id: "some user_id"}
  @update_attrs %{email: "some.updated@email.com", name: "some updated name", password: "some updated password", user_id: "some updated user_id"}
  @invalid_attrs %{email: nil, name: nil, passwordHash: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end



  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_api_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_api_path(conn, :create), user: @create_attrs)
      assert %{"user_id" => user_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_api_path(conn, :show, user_id))

      assert @create_attrs = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_api_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{user_id: user_id} = user} do
      conn = put(conn, Routes.user_api_path(conn, :update, user_id), user: @update_attrs)
      assert %{"user_id" => ^user_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_api_path(conn, :show, user_id))

      assert @update_attrs = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: %User{user_id: user_id} = user} do
      conn = put(conn, Routes.user_api_path(conn, :update, user_id), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: %User{user_id: user_id} = user} do
      conn = delete(conn, Routes.user_api_path(conn, :delete, user_id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_api_path(conn, :show, user))
      end
    end
  end

  defp create_user (%{conn: conn}) do
    user = Twitterclone.UserContext.preload_key(user_fixture())
    conn = put_req_header(conn, "x-api-key", user.api_key.key)
    %{user: user, conn: conn}
  end
end
