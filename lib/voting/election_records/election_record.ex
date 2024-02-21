defmodule Voting.ElectionRecords.ElectionRecord do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: false}

  schema "electionrecords" do
    field :owner, :integer
    field :type, :string
    field :candidates, {:array, :string}
    field :ballots, :map
    field :winner, :string

    timestamps(type: :utc_datetime)
  end

  @doc false

  def changeset(election_record, attrs) do     

    
    election_record
    |> cast(attrs, [:id, :winner, :type, :ballots, :candidates, :owner])
    |> validate_required([:id, :owner])
  end
end

