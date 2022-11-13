defmodule Twitterclone.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :newmsg, {:array, :string}

      timestamps()
    end

    create table(:roomconnections) do
      add :user_id, references(:users, type: :string,  column: :user_id, on_delete: :delete_all), null: false
      add :room_id, references(:rooms), null: false
    end
  end
end
