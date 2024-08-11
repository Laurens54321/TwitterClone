defmodule Twitterclone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :user_id, :string, null: false, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :passwordHash, :string, null: false
      add :role, :string, null: false
      add :picture_url, :string, null: true

      timestamps()
    end

    create unique_index(:users, :user_id,
              name: :unique_user_id_index)

    create unique_index(:users, :email,
              name: :unique_email_index)
  end
end
