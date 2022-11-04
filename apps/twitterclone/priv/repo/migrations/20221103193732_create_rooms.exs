defmodule Twitterclone.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string

      timestamps()
    end

    create table(:roomconnections) do
      add :user_id, references(:users, type: :string,  column: :user_id), null: false
      add :room_id, references(:rooms), null: false

      timestamps()
    end
  end
end
