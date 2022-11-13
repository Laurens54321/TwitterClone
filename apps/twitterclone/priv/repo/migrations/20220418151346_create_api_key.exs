defmodule Twitterclone.Repo.Migrations.CreateAPIKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :key, :string
      add :user_id, references(:users, type: :string,  column: :user_id, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:api_keys, [:user_id])
  end
end
