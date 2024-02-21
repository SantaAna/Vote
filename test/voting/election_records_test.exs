defmodule Voting.ElectionRecordsTest do
  use Voting.DataCase

  alias Voting.ElectionRecords

  describe "electionrecords" do
    alias Voting.ElectionRecords.ElectionRecord

    import Voting.ElectionRecordsFixtures

    @invalid_attrs %{owner: nil, type: nil, candidates: nil, ballots: nil}

    test "list_electionrecords/0 returns all electionrecords" do
      election_record = election_record_fixture()
      assert ElectionRecords.list_electionrecords() == [election_record]
    end

    test "get_election_record!/1 returns the election_record with given id" do
      election_record = election_record_fixture()
      assert ElectionRecords.get_election_record!(election_record.id) == election_record
    end

    test "create_election_record/1 with valid data creates a election_record" do
      valid_attrs = %{owner: "some owner", type: "some type", candidates: ["option1", "option2"], ballots: ["option1", "option2"]}

      assert {:ok, %ElectionRecord{} = election_record} = ElectionRecords.create_election_record(valid_attrs)
      assert election_record.owner == "some owner"
      assert election_record.type == "some type"
      assert election_record.candidates == ["option1", "option2"]
      assert election_record.ballots == ["option1", "option2"]
    end

    test "create_election_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ElectionRecords.create_election_record(@invalid_attrs)
    end

    test "update_election_record/2 with valid data updates the election_record" do
      election_record = election_record_fixture()
      update_attrs = %{owner: "some updated owner", type: "some updated type", candidates: ["option1"], ballots: ["option1"]}

      assert {:ok, %ElectionRecord{} = election_record} = ElectionRecords.update_election_record(election_record, update_attrs)
      assert election_record.owner == "some updated owner"
      assert election_record.type == "some updated type"
      assert election_record.candidates == ["option1"]
      assert election_record.ballots == ["option1"]
    end

    test "update_election_record/2 with invalid data returns error changeset" do
      election_record = election_record_fixture()
      assert {:error, %Ecto.Changeset{}} = ElectionRecords.update_election_record(election_record, @invalid_attrs)
      assert election_record == ElectionRecords.get_election_record!(election_record.id)
    end

    test "delete_election_record/1 deletes the election_record" do
      election_record = election_record_fixture()
      assert {:ok, %ElectionRecord{}} = ElectionRecords.delete_election_record(election_record)
      assert_raise Ecto.NoResultsError, fn -> ElectionRecords.get_election_record!(election_record.id) end
    end

    test "change_election_record/1 returns a election_record changeset" do
      election_record = election_record_fixture()
      assert %Ecto.Changeset{} = ElectionRecords.change_election_record(election_record)
    end
  end
end
