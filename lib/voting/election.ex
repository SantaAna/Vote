defmodule Voting.Election do
  defstruct [:type, :ballots, :candidates, :id, :owner]

  @new_options_schema [
    ballots: [
      type: {:list, {:list, :string}},
      doc: "Optional list of string lists that represent ballots"
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
      type: :string,
      required: false,
      doc: "A string that identifies the owner of the election."
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
      ballots: Keyword.get(opts, :ballots, []), 
      candidates: opts[:candidates],
      id: opts[:id], 
      owner: opts[:owner]
    }
  end

  def submit_ballot(%__MODULE__{} = election, ballot) do
    Map.update!(election, :ballots, & [ballot | &1])
  end

  def run_election(%__MODULE__{ballots: ballots, type: type}) do
       type.run(ballots) 
  end
end
