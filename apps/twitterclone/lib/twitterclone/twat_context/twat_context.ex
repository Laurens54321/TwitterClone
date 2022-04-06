defmodule Twitterclone.TwatContext do
  @moduledoc """
  The TwatContext context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo

  alias Twitterclone.TwatContext.Twat

  @doc """
  Returns the list of twats.

  ## Examples

      iex> list_twats()
      [%Twat{}, ...]

  """
  def list_twats do
    Repo.all(Twat)
  end

  @doc """
  Gets a single twat.

  Raises `Ecto.NoResultsError` if the Twat does not exist.

  ## Examples

      iex> get_twat!(123)
      %Twat{}

      iex> get_twat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_twat!(id), do: Repo.get!(Twat, id)

  @doc """
  Creates a twat.

  ## Examples

      iex> create_twat(%{field: value})
      {:ok, %Twat{}}

      iex> create_twat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_twat(attrs \\ %{}) do
    %Twat{}
    |> Twat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a twat.

  ## Examples

      iex> update_twat(twat, %{field: new_value})
      {:ok, %Twat{}}

      iex> update_twat(twat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_twat(%Twat{} = twat, attrs) do
    twat
    |> Twat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a twat.

  ## Examples

      iex> delete_twat(twat)
      {:ok, %Twat{}}

      iex> delete_twat(twat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_twat(%Twat{} = twat) do
    Repo.delete(twat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking twat changes.

  ## Examples

      iex> change_twat(twat)
      %Ecto.Changeset{data: %Twat{}}

  """
  def change_twat(%Twat{} = twat, attrs) do
    Twat.changeset(twat, attrs)
  end

  def change_twat(%Twat{} = twat) do
    Ecto.Changeset.change(twat)
  end

  def get_by_userid(user_id) do
    recording_query = from(t in Twat, where: like(t.user_id, ^user_id))
    Repo.all(recording_query)
  end
end
