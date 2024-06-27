defmodule Flamel.BooleanTest do
  use ExUnit.Case

  doctest Flamel.Atom

  describe "to/1" do
    test "returns boolean for a string" do
      assert Flamel.Boolean.to("Y")
      assert Flamel.Boolean.to("y")
      assert Flamel.Boolean.to("YES")
      assert Flamel.Boolean.to("Yes")
      assert Flamel.Boolean.to("yes")
      assert Flamel.Boolean.to("true")
      assert Flamel.Boolean.to("TRUE")
      assert Flamel.Boolean.to("1")
      refute Flamel.Boolean.to("N")
      refute Flamel.Boolean.to("n")
      refute Flamel.Boolean.to("NO")
      refute Flamel.Boolean.to("No")
      refute Flamel.Boolean.to("no")
      refute Flamel.Boolean.to("false")
      refute Flamel.Boolean.to("FALSE")
      refute Flamel.Boolean.to("0")
    end
  end
end
