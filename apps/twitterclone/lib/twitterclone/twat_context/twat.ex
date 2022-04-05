defmodule Twitterclone.TwatContext.Twat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.UserContext.User
  alias Twitterclone.UserContext

  schema "twats" do
    field :twat_id, :string
    field :creationDate, :date
    field :text, :string
    belongs_to :user, User, foreign_key: :user_id, references: :user_id
    has_many :comments, Twitterclone.CommentContext.Comment

    timestamps()
  end

  @doc false
  def changeset(twat, attrs) do
    twat
    |> cast(attrs, [:twat_id, :text, :creationDate])
    |> validate_required([:twat_id, :text, :creationDate])
    |> create_relation()
  end

  defp create_relation(%Ecto.Changeset{valid?: true, changes: %{user_id: user_id} = changeset}) do
    user = UserContext.get_user(user_id)
    put_assoc(changeset, :user_id, user)
  end

  defp create_relation(changeset), do: changeset
end
