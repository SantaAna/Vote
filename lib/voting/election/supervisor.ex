defmodule Voting.Election.Supervisor do
  use DynamicSupervisor
  import UUID, only: [uuid4: 0]

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
  

  def new_election(opts) do
    id = uuid4()
    IO.inspect(opts, label: "opts")
    opts = put_in(opts, [:election_opts, :id], id) 
    result =
      DynamicSupervisor.start_child(
        __MODULE__,
        %{
          id: id,
          start: {Voting.Election.Server, :start_link, [opts[:election_opts], opts[:server_opts]]},
          restart: :temporary
        }
      )

    case result do
      {:ok, _} -> {:ok, id}
      error_tup -> error_tup
    end
  end
end
