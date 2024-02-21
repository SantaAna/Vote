defmodule Voting.Election.Server do
  use GenServer
  require Logger
  import Voting.Election.Registry, only: [via_tuple: 1]
  alias Voting.Election

  # client
  def start_link(election_opts, server_opts) do
    default_server_opts = [
      notify_function: fn x -> Logger.info(x) end,
      persist_function: fn x -> IO.inspect(x, label: "persisted!") end
    ]

    election = Voting.Election.new(election_opts[:type], id: election_opts[:id])
    server_opts = Keyword.merge(default_server_opts, server_opts) |> Map.new()
    GenServer.start_link(Voting.Election.Server, {election, server_opts}, name: via_tuple(election_opts[:id]))
  end

  @impl true
  def init(election) do
    {:ok, election}
  end

  def get_id(name) do
    GenServer.call(via_tuple(name), :get_id)
  end

  @impl true
  def handle_call(:get_id, _from, {%{id: id} = election, _}), do: {:reply, id, election}

  def submit_ballot(name, ballot) do
    GenServer.cast(via_tuple(name), {:submit, ballot})
  end

  @impl true
  def handle_cast({:submit, ballot}, {election, %{notify_function: nf}}) do
    nf.("ballot added: #{ballot}")
    {:noreply, Election.submit_ballot(election, ballot)}
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
end
