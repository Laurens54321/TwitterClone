defmodule TwittercloneWeb.TwatControllerTest do
  use TwittercloneWeb.ConnCase

  import Twitterclone.TwatContextFixtures

  alias Twitterclone.TwatContext.Twat

  @create_attrs %{
    creationDate: ~D[2022-03-17],
    text: "some text"
  }
  @update_attrs %{
    creationDate: ~D[2022-03-18],
    text: "some updated text"
  }
  @invalid_attrs %{creationDate: nil, text: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all twats", %{conn: conn} do
      conn = get(conn, Routes.twat_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create twat" do
    test "renders twat when data is valid", %{conn: conn} do
      conn = post(conn, Routes.twat_path(conn, :create), twat: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.twat_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "creationDate" => "2022-03-17",
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.twat_path(conn, :create), twat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update twat" do
    setup [:create_twat]

    test "renders twat when data is valid", %{conn: conn, twat: %Twat{id: id} = twat} do
      conn = put(conn, Routes.twat_path(conn, :update, twat), twat: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.twat_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "creationDate" => "2022-03-18",
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, twat: twat} do
      conn = put(conn, Routes.twat_path(conn, :update, twat), twat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete twat" do
    setup [:create_twat]

    test "deletes chosen twat", %{conn: conn, twat: twat} do
      conn = delete(conn, Routes.twat_path(conn, :delete, twat))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.twat_path(conn, :show, twat))
      end
    end
  end

  defp create_twat(_) do
    twat = twat_fixture()
    %{twat: twat}
  end
end
