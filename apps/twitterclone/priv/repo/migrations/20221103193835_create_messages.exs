defmodule Twitterclone.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :room_id, references(:rooms), null: false
      add :user_id, references(:users, type: :string,  column: :user_id)
      add :replyto_id, references(:messages), null: true

      timestamps()
    end
    create index(:messages, [:replyto_id])
  end
end
