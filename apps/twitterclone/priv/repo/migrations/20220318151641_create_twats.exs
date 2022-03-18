defmodule Twitterclone.Repo.Migrations.CreateTwats do
  use Ecto.Migration

  def change do
    create table(:twats) do
      add :twat_id, :string
      add :text, :string
      add :creationDate, :date
      add :user_id, references(:users)

      timestamps()
    end
  end
end
