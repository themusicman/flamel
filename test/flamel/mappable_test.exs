defmodule Flamel.MappableTest do
  use ExUnit.Case

  doctest Flamel.Mappable

  defmodule Person do
    @moduledoc false
    defstruct name: "", dob: ""
  end

  describe "to/1" do
    test "returns map for a struct" do
      assert Flamel.Mappable.to(%Person{name: "Bill", dob: "1908/12/12"}) == %{
               name: "Bill",
               dob: "1908/12/12"
             }
    end

    test "returns map for a map" do
      assert Flamel.Mappable.to(%{name: "Bill", dob: "1908/12/12"}) == %{
               name: "Bill",
               dob: "1908/12/12"
             }
    end

    test "returns map for any invalid type" do
      assert Flamel.Mappable.to(nil) == %{}
    end
  end
end
