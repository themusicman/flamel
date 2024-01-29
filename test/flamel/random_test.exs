defmodule Flamel.RandomTest do
  use ExUnit.Case

  describe "string/1" do
    test "returns a random string" do
      str = Flamel.Random.string()
      assert String.length(str) == 10
    end
  end
end
