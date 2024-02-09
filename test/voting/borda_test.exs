defmodule Voting.BordaTest do
  use ExUnit.Case
  alias Voting.Borda, as: B

  describe "score_ballot/2" do
    test "correctly scores full ballot" do
      assert B.score_ballot(~w(a b c), 3) == %{"a" => 2, "b" => 1, "c" => 0}
    end

    test "correctly scores partial ballot" do
      assert B.score_ballot(~w(a b), 3) == %{"a" => 2, "b" => 1}
    end
  end

  describe "score_ballots/2" do
    test "correclty scores full ballots" do
      assert B.score_ballots([~w(b a c), ~w(a b c)], 3) == %{"a" => 3, "b" => 3, "c" => 0}
    end

    test "correclty scores partial ballots" do
      assert B.score_ballots([~w(b a), ~w(a c)], 3) == %{"a" => 3, "b" => 2, "c" => 1}
    end

    test "correclty scores mixed ballots" do
      assert B.score_ballots([~w(b a c), ~w(b c)], 3) == %{"a" => 1, "b" => 4, "c" => 1}
    end
  end

  describe "determine_result/1" do
    test "recognizes a winner" do
      assert B.determine_result([{"a", 4}, {"b", 3}]) == {:winner, "a"}
    end

    test "recognizes a tie" do
      assert B.determine_result([{"a", 4}, {"b", 4}]) == {:tie, ["a", "b"]}
    end
  end

  describe "run/1" do
    test "recognizes a winner" do
      assert B.run([~w(a b c), ~w(a b c), ~w(b a c)], 3) == {:winner, "a"}
    end

    test "recognizes a tie" do
      assert B.run([~w(a c b), ~w(b c a)], 2) == {:tie, ~w(a b)}
    end
  end
end
