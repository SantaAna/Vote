defmodule Voting.ElectionRecordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voting.ElectionRecords` context.
  """

  @doc """
  Generate a election_record.
  """
  def election_record_fixture(attrs \\ %{}) do
    {:ok, election_record} =
      attrs
      |> Enum.into(%{
        ballots: ["option1", "option2"],
        candidates: ["option1", "option2"],
        owner: "some owner",
        type: "some type"
      })
      |> Voting.ElectionRecords.create_election_record()

    election_record
  end
end
