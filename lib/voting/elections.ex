defmodule Voting.Elections do
  @moduledoc """
  The ElectionRecords context.
  """

  import Ecto.Query, warn: false
  alias Voting.Repo

  alias Voting.ElectionRecords.ElectionRecord

  @election_types [Voting.Borda]

  @doc """
  Returns the list of electionrecords.

  ## Examples

      iex> list_electionrecords()
      [%ElectionRecord{}, ...]

  """
  def list_electionrecords do
    Repo.all(ElectionRecord)
  end

  @doc """
  Gets a single election_record.

  Raises `Ecto.NoResultsError` if the Election record does not exist.

  ## Examples

      iex> get_election_record!(123)
      %ElectionRecord{}

      iex> get_election_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_election_record!(id), do: Repo.get!(ElectionRecord, id)

  def get_election_record(id), do: Repo.get(ElectionRecord, id)

  @doc """
  Creates a election_record.

  ## Examples

      iex> create_election_record(%{field: value})
      {:ok, %ElectionRecord{}}

      iex> create_election_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_election_record(attrs \\ %{})

  def create_election_record(%{type: type} = attrs) when is_atom(type) do
    type =
      type
      |> to_string()
      |> String.split(".")
      |> List.last()

    create_election_record(%{attrs | type: type})
  end

  def create_election_record(attrs) do
    %ElectionRecord{}
    |> ElectionRecord.changeset(attrs)
    |> Repo.insert()
  end

  def create_or_update_election_record(%{id: id} = attrs) when is_binary(id) do
    case get_election_record(id) do
      nil ->
        create_election_record(attrs)
      current -> 
        delete_election_record(current)
        create_election_record(attrs)
    end
  end

  @doc """
  Updates a election_record.

  ## Examples

      iex> update_election_record(election_record, %{field: new_value})
      {:ok, %ElectionRecord{}}

      iex> update_election_record(election_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_election_record(%ElectionRecord{} = election_record, attrs) do
    election_record
    |> ElectionRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a election_record.

  ## Examples

      iex> delete_election_record(election_record)
      {:ok, %ElectionRecord{}}

      iex> delete_election_record(election_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_election_record(%ElectionRecord{} = election_record) do
    Repo.delete(election_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking election_record changes.

  ## Examples

      iex> change_election_record(election_record)
      %Ecto.Changeset{data: %ElectionRecord{}}

  """
  def change_election_record(%ElectionRecord{} = election_record, attrs \\ %{}) do
    ElectionRecord.changeset(election_record, attrs)
  end

  def start_election(type, id) when type in @election_types do
    Voting.Election.Supervisor.new_election(
      type,
      election_opts: [owner: id],
      server_opts: [persist_function: &create_or_update_election_record/1]
    )
  end

  def start_election(_type),
    do:
      {:error,
       "invalid election type, type must be one of the following modules #{Enum.map(@election_types, &to_string/1) |> Enum.join(", ")}"}
end
