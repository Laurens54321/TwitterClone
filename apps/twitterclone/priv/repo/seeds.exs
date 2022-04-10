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
    "creationDate" => "2022-04-05 11:53:40",
    "text" => "First tweet!",
    "user_id" => "admin"})

{:ok, _cs} =
  Twitterclone.TwatContext.create_twat(%{
    "creationDate" => "2022-04-06 11:53:40",
    "text" => "Another tweet!",
    "user_id" => "admin"})

{:ok, _cs} =
  Twitterclone.TwatContext.create_twat(%{
    "creationDate" => "2022-04-09 11:53:40",
    "text" => "Subtweet!",
    "user_id" => "user",
    "parent_twat" => 1})


{:ok, _cs} =
  Twitterclone.UserContext.create_follower(%{
    "user_id" => "admin",
    "follower_id" => "user"})
