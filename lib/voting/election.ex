defmodule Voting.Election do
  defstruct [type: nil, ballots: %{}, candidates: nil, id: nil, owner: nil]

  @new_options_schema [
    ballots: [
      type: {:map, :string, {:list, :string}}, 
      doc: "Optional list of string lists that represent ballots",
      default: %{}
    ],
    candidates: [
      type: {:list, :string},
      doc: "Optional list of strings that represent election candidates"
    ],
    id: [
      type: :string,
      required: true,
      doc: "A unique string ID for identifying an election."
    ],
    owner: [
      type: :integer,
      required: false,
      doc: "An integer that identifies the owner of the election"
    ]
  ]

  @doc """
  Creates a new election struct.
  
  ## Options
  #{NimbleOptions.docs(@new_options_schema)}
  """
  def new(type, opts \\ []) do
    NimbleOptions.validate!(opts, @new_options_schema)

    %__MODULE__{
      type: type,
      ballots: Keyword.get(opts, :ballots, %{}), 
      candidates: opts[:candidates],
      id: opts[:id], 
      owner: opts[:owner]
    }
  end

  def submit_ballot(%__MODULE__{} = election, voter_id, ballot) do
    Map.update!(election, :ballots, &Map.put(&1, voter_id, ballot))
  end

  def run_election(%__MODULE__{ballots: ballots, type: type}) do
       type.run(ballots) 
  end
end
