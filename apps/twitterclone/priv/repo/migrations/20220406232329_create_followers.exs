defmodule Twitterclone.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :user_id, references(:users, type: :string,  column: :user_id, null: false, on_delete: :delete_all)
      add :follower_id, references(:users, type: :string,  column: :user_id, null: false)

      timestamps()
    end

    create unique_index(
      :followers, [:user_id, :follower_id],
      name: :follower_user_id_follower_id_match
      )

    create unique_index(
      :followers, [:follower_id, :user_id],
      name: :follower_follower_id_user_id_match
      )

  end
end
