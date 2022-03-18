defmodule Twitterclone.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment_id, :string
      add :text, :string
      add :creationDate, :date
      add :twat_id, references(:twats)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
