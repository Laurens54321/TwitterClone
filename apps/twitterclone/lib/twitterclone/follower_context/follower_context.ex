defmodule Twitterclone.FollowerContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  require Logger
  alias Twitterclone.FollowerContext.Follower

  def list_followers do
    Repo.all(Follower)
  end

  def is_following(user_id, follower_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id) and like(u.follower_id, ^follower_id))
    if Repo.one(query), do: True
    False
  end

  def get_follower!(user_id), do: Repo.get!(Follower, user_id)

  def get_following(user_id) do
    query = from(u in Follower, where: like(u.follower_id, ^user_id))
    Repo.all(query)
  end

  def get_followers(user_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id))
    Repo.all(query)
  end

  def get_follower_record(user_id, follower_id) do
    query = from(u in Follower, where: like(u.user_id, ^user_id) and like(u.follower_id, ^follower_id))
    case Repo.one(query) do
      %Follower{} = follower -> follower
      nil -> {:error, :not_found}
    end
  end

  def create_follower(attrs \\ %{}) do
    %Follower{}
    |> Follower.changeset(attrs)
    |> Repo.insert()
  end

  def update_follower(%Follower{} = follower, attrs) do
    follower
    |> Follower.changeset(attrs)
    |> Repo.update()
  end

  def delete_follower(%Follower{} = follower) do
    Repo.delete(follower)
  end

  def change_follower(%Follower{} = follower, attrs \\ %{}) do
    Follower.changeset(follower, attrs)
  end
end
