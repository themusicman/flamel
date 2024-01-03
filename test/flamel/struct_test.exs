defmodule Flamel.StructTest do
  use ExUnit.Case

  defmodule Person do
    defstruct name: "", dob: ""
  end

  alias Person

  describe "fields/1" do
    test "returns a list of fields from passed a struct" do
      fields = Flamel.Struct.fields(%Person{})
      assert fields == [:name, :dob]
    end

    test "returns an empty list when passed something that is not a struct" do
      fields = Flamel.Struct.fields(nil)
      assert fields == []
    end
  end
end
