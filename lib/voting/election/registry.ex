defmodule Voting.Election.Registry do
  def via_tuple(election_id) do
    {:via, Registry, {__MODULE__, election_id}}
  end

  def child_spec(_) do
    Registry.child_spec([keys: :unique, name: __MODULE__, id: __MODULE__])
  end
end
