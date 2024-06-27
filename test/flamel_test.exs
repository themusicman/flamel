defmodule FlamelTest do
  use ExUnit.Case

  doctest Flamel

  describe "unwrap_ok!/1 forwarding" do
    test "returns value unwrapped from an ok tuple" do
      assert Flamel.unwrap_ok!({:ok, :test}) == :test
    end
  end
end
