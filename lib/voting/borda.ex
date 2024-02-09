defmodule Voting.Borda do
  @moduledoc """
  Functions for finding a winner
  using the Borda ranked choice method
  """

  @type ballot() :: [String.t()]
  @type vote_tally() :: %{String.t() => integer()}
  @type result() :: {:winner, String.t()} | {:tie, [String.t()]}

  @spec run(ballots :: [ballot()], candidate_count :: integer()) :: result()
  def run(ballots, candidate_count) do
    ballots
    |> score_ballots(candidate_count)
    |> Enum.sort_by(fn {_k, v} -> v end, :desc)
    |> determine_result()
  end

  @spec determine_result(list({String.t(), integer()})) :: result()
  def determine_result(sorted_counts) do
    {_, m} = hd(sorted_counts)
    ties = Enum.take_while(sorted_counts, fn {_, c} -> c == m end)

    if length(ties) > 1 do
      {:tie, Enum.map(ties, &elem(&1, 0))}
    else
      {:winner, elem(hd(ties), 0)}
    end
  end

  @spec score_ballots(ballots :: [ballot()], candidate_count :: integer()) :: [vote_tally()]
  def score_ballots(ballots, candidate_count) do
    ballots
    |> Enum.map(&score_ballot(&1, candidate_count))
    |> Enum.reduce(%{}, fn b, a ->
      Map.merge(b, a, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  @spec score_ballot(ballot :: ballot(), candidate_count :: integer()) :: vote_tally()
  def score_ballot(ballot, candidate_count) do
    score_range = (candidate_count - 1)..0//-1

    ballot
    |> Enum.zip(score_range)
    |> Map.new()
  end
end
