defmodule Twitterclone.Repo.Migrations.CreateTwats do
  use Ecto.Migration

  def change do
    create table(:twats) do
      add :text, :string
      add :creationDate, :date
      add :user_id, references(:users, type: :string,  column: :user_id)
      add :parent_twat, references(:twats, name: :parent_twat), null: true

      timestamps()
    end
  end
end
