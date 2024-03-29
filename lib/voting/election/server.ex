defmodule Voting.Election.Server do
  use GenServer
  require Logger
  import Voting.Election.Registry, only: [via_tuple: 1]
  alias Voting.Election

  # client
  def start_link(type, election_opts, server_opts) do
    default_server_opts = [
      notify_function: fn x -> Logger.info(x) end,
      persist_function: fn x -> IO.inspect(x, label: "persisted!") end
    ]

    election = Voting.Election.new(type, election_opts)
    server_opts = Keyword.merge(default_server_opts, server_opts) |> Map.new()

    GenServer.start_link(Voting.Election.Server, {election, server_opts}, name: via_tuple(election_opts[:id]))
  end

  @impl true
  def init(election) do
    IO.inspect(election, label: "election server state")
    {:ok, election}
  end

  def get_id(name) do
    GenServer.call(via_tuple(name), :get_id)
  end

  @impl true
  def handle_call(:get_id, _from, {%{id: id} = election, _} = state), do: {:reply, id, state}

  def submit_ballot(name, voter_id, ballot) do
    GenServer.cast(via_tuple(name), {:submit, ballot, voter_id})
  end

  def submit_ballot(name, ballot) do
    GenServer.cast(via_tuple(name), {:submit, ballot, "anon"})
  end

  @impl true
  def handle_cast({:submit, ballot, voter_id}, {election, %{notify_function: nf} = server_opts}) do
    nf.("ballot added: #{ballot}")
    {:noreply, {Election.submit_ballot(election,voter_id,ballot), server_opts}}
  end

  def run_election(name) do
    GenServer.call(via_tuple(name), :run_election)
  end

  @impl true
  def handle_call(:run_election, _from, {%{ballots: []}, _} = state) do
    {:reply, {:error, "cannot run election without ballots!"}, state}
  end

  def handle_call(:run_election, _from, {election, %{notify_function: nf}} = state) do
    nf.("election run for election with id #{election.id}")
    {:reply, {:ok, Election.run_election(election)}, state}
  end

  def stop_election(name) do
    GenServer.cast(via_tuple(name), :stop_election)
  end

  @impl true
  def handle_cast(:stop_election, {election, %{notify_function: nf}} = state) do
    nf.("election stoped for election with id #{election.id}")
    {:stop, :normal, state}
  end

  def save_election(name) do
    GenServer.call(via_tuple(name), :save_election)
  end

  @impl true
  def handle_call(:save_election, _from, {election, %{persist_function: pf}} = state) do
    result = pf.(Map.from_struct(election))
    {:reply, result, state}
  end
end
