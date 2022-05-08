defmodule Twitterclone.Repo.Migrations.CreateTwats do
  use Ecto.Migration

  def change do
    create table(:twats) do
      add :text, :string
      add :user_id, references(:users, type: :string,  column: :user_id, on_delete: :delete_all)

      timestamps()
    end
  end
end
