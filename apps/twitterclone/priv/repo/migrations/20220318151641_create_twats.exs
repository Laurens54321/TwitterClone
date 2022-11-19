defmodule Twitterclone.Repo.Migrations.CreateTwats do
  use Ecto.Migration

  def change do
    create table(:twats) do
      add :text, :string
      add :user_id, references(:users, type: :string, column: :user_id), null: false
      add :replyto_id, references(:twats, on_delete: :delete_all), null: true

      timestamps()
    end
    create index(:twats, [:replyto_id])
  end
end
