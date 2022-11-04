# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twitterclone.Repo.insert!(%Twitterclone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _cs} =
  Twitterclone.UserContext.create_user(%{
    "user_id" => "user",
    "name" => "user 1",
    "email" => "user@mail.com",
    "password" => "t",
    "role" => "User"
    })

{:ok, _cs} =
  Twitterclone.UserContext.create_user(%{
    "user_id" => "manager",
    "name" => "manager 1",
    "email" => "manager@mail.com",
    "password" => "t",
    "role" => "Manager"
  })

{:ok, _cs} =
  Twitterclone.UserContext.create_user(%{
    "user_id" => "admin",
    "name" => "admin 1",
    "email" => "admin@mail.com",
    "password" => "t",
    "role" => "Admin" })

{:ok, _cs} =
  Twitterclone.UserContext.create_user(%{
    "user_id" => "4",
    "name" => "user 1",
    "email" => "usernumberfour@mail.com",
    "password" => "t",
    "role" => "User"
    })

{:ok, _cs} =
  Twitterclone.TwatContext.create_twat(%{
    "text" => "First tweet!",
    "user_id" => "admin"})

{:ok, _cs} =
  Twitterclone.TwatContext.create_twat(%{
    "text" => "Another tweet!",
    "user_id" => "admin"})

{:ok, _cs} =
  Twitterclone.TwatContext.create_twat(%{
    "text" => "First tweet by user",
    "user_id" => "user"})

{:ok, _cs} =
  Twitterclone.CommentContext.create_comment(%{
    "text" => "Comment",
    "user_id" => "user",
    "twat_id" => 1})

{:ok, _cs} =
  Twitterclone.UserContext.create_follower(%{
    "user_id" => "admin",
    "follower_id" => "user"})

{:ok, _cs} =
  Twitterclone.UserContext.create_follower(%{
    "user_id" => "manager",
    "follower_id" => "user"})

{:ok, _cs} =
  Twitterclone.UserContext.create_follower(%{
    "user_id" => "4",
    "follower_id" => "user"})

{:ok, _cs} =
  Twitterclone.UserContext.create_api_key(%{
    "user_id" => "user",
    "key" => "E99E446982E747F649A8A5B26ACB79F761649DD58D25A80D133D2E6D1E79350"})

{:ok, room} =
  Twitterclone.RoomContext.create_room(
    ["admin", "user"]
  )

{:ok, _cs} =
  Twitterclone.RoomContext.create_message(%{
    "user_id" => "admin",
    "text" => "first msg",
    "room_id" => room.id})
