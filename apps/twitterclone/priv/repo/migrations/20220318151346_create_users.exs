defmodule Twitterclone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :passwordHash, :string, null: false
      add :role, :string, null: false

      timestamps()
    end
  end
end
