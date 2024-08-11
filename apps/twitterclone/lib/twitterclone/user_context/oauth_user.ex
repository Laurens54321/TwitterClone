defmodule Twitterclone.UserContext.OauthUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User

  schema "oauth_users" do
    field :sub_token, :string
    field :domain, :string
    field :email, :string
    field :name, :string
    field :picture_url, :string
    belongs_to :user, User, foreign_key: :user_id, references: :user_id, type: :string

  end

  @doc false
  def changeset(oauthuser, attrs) do
    oauthuser
    |> cast(attrs, [:sub_token, :domain, :email, :name, :picture_url, :user_id,])
    |> validate_required([:sub_token, :domain, :email, :name])
    |> foreign_key_constraint(:user_id, name: :oauth_user_id_fkey)
  end

end
