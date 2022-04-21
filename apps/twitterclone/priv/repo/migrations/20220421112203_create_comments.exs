defmodule Twitterclone.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string
      add :twat_id, references(:twats)
      add :user_id, references(:users, type: :string,  column: :user_id)

      timestamps()
    end
  end
end
