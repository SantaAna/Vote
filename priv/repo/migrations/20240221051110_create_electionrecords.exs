defmodule Voting.Repo.Migrations.CreateElectionrecords do
  use Ecto.Migration

  def change do
    create table(:electionrecords, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :ballots, :map 
      add :candidates, {:array, {:array, :string}}
      add :owner, :integer
      add :winner, :string

      timestamps(type: :utc_datetime)
    end
  end
end
