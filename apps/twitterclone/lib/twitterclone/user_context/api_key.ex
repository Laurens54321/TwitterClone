defmodule Twitterclone.UserContext.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_keys" do
    field :key, :string
    belongs_to :user, Twitterclone.UserContext.User, foreign_key: :user_id, references: :user_id, type: :string

    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:key, :user_id])
    |> validate_required([:key, :user_id])
  end
end
