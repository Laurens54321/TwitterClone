defmodule TwittercloneWeb.FollowerControllerTest do
  use TwittercloneWeb.ConnCase

  import Twitterclone.UserContextFixtures

  alias Twitterclone.UserContext.Follower

  @create_attrs %{
    follower_id: "some follower_id",
    user_id: "some user_id"
  }
  @update_attrs %{
    follower_id: "some updated follower_id",
    user_id: "some updated user_id"
  }
  @invalid_attrs %{follower_id: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all followers", %{conn: conn} do
      conn = get(conn, Routes.follower_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create follower" do
    test "renders follower when data is valid", %{conn: conn} do
      conn = post(conn, Routes.follower_path(conn, :create), follower: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.follower_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "follower_id" => "some follower_id",
               "user_id" => "some user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.follower_path(conn, :create), follower: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update follower" do
    setup [:create_follower]

    test "renders follower when data is valid", %{conn: conn, follower: %Follower{id: id} = follower} do
      conn = put(conn, Routes.follower_path(conn, :update, follower), follower: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.follower_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "follower_id" => "some updated follower_id",
               "user_id" => "some updated user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, follower: follower} do
      conn = put(conn, Routes.follower_path(conn, :update, follower), follower: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete follower" do
    setup [:create_follower]

    test "deletes chosen follower", %{conn: conn, follower: follower} do
      conn = delete(conn, Routes.follower_path(conn, :delete, follower))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.follower_path(conn, :show, follower))
      end
    end
  end

  defp create_follower(_) do
    follower = follower_fixture()
    %{follower: follower}
  end
end
