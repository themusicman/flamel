defmodule Flamel.MapTest do
  use ExUnit.Case
  doctest Flamel.Map

  defmodule Person do
    defstruct name: "", dob: ""
  end

  alias Person

  describe "atomize_map/1 when the map includes a struct" do
    test "returns map with atom keys if map includes a DateTime" do
      datetime = ~U[2023-12-01 01:00:00Z]
      data = %{"dob" => datetime}

      assert Flamel.Map.atomize_keys(data) == %{dob: ~U[2023-12-01 01:00:00Z]}
    end

    test "returns map with atom keys if map includes a struct" do
      person = %Person{name: "Jill"}
      data = %{"person" => person}

      assert Flamel.Map.atomize_keys(data) == %{person: person}
    end
  end
end
