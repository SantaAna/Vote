defmodule Voting.IdGen do
  @moduledoc """
  Create random base 36 strings for 
  unique URLs
  """ 
  
  @charset String.graphemes("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")  

  def random(length) do
    Enum.shuffle(@charset)
    |> Enum.take(length)
    |> Enum.join("")
  end
end
