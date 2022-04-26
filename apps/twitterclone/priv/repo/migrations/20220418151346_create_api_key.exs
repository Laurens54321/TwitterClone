defmodule Twitterclone.Repo.Migrations.CreateAPIKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :key, :string
      add :user_id, references(:users, type: :string,  column: :user_id)

      timestamps()
    end
  end
end
