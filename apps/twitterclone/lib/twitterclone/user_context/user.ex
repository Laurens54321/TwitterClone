defmodule Twitterclone.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  @acceptable_roles ["Admin", "Manager", "User"]

  @primary_key {:user_id, :string, []}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :passwordHash, :string
    field :role, :string, default: "User"
    has_many :twats, Twitterclone.TwatContext.Twat, foreign_key: :user_id
    has_many :comments, Twitterclone.CommentContext.Comment, foreign_key: :user_id

    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :name, :email, :password, :role])
    |> validate_required([:user_id, :name, :email, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, passwordHash: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
