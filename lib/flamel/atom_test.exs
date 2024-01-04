defmodule Flamel.AtomTest do
  use ExUnit.Case
  doctest Flamel.Atom

  describe "to/1" do
    test "returns atom for a string" do
      assert Flamel.Atom.to("test") == :test
    end

    test "returns atom for an integer" do
      assert Flamel.Atom.to("1") == :"1"
    end

    test "returns atom for an float" do
      assert Flamel.Atom.to("1.2") == :"1.2"
    end

    test "returns atom for an atom" do
      assert Flamel.Atom.to(:test) == :test
    end

    test "returns nil for any invalid type" do
      assert Flamel.Atom.to(nil) == nil
    end
  end
end
