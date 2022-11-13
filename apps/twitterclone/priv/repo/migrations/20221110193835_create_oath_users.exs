defmodule Twitterclone.Repo.Migrations.CreateOauthUsers do
  use Ecto.Migration

  def change do
    create table(:oauth_users) do
      add :sub_token, :string
      add :domain, :string
      add :email, :string
      add :name, :string
      add :picture_url, :string
      add :user_id, references(:users, type: :string,  column: :user_id), null: true

    end
  end
end
