defmodule Flamel.MapTest do
  use ExUnit.Case
  doctest Flamel.Map

  defmodule Person do
    defstruct name: "", dob: "", address: nil
  end

  defmodule Address do
    defstruct street: "", zip_code: ""
  end

  alias Person
  alias Address

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

  describe "assign/3 pushing a list of items" do
    test "push a list of items" do
      map =
        Flamel.Map.assign(
          %{assigns: %{hobbies: ["playing"]}},
          :assigns,
          set: [name: "Osa"],
          push: [hobbies: ["soccer", "coloring"]]
        )

      assert get_in(map, [:assigns, :hobbies]) == ["soccer", "coloring", "playing"]
      assert get_in(map, [:assigns, :name]) == "Osa"
    end
  end

  describe "put_if_blank/3" do
    test "when value is blank puts value in map" do
      values =
        Flamel.Map.put_if_blank(
          %{first_name: nil},
          :first_name,
          fn -> "Bob" end
        )

      assert values[:first_name] == "Bob"
    end

    test "when value is not blank does not put value in map" do
      values =
        Flamel.Map.put_if_blank(
          %{first_name: "Jill"},
          :first_name,
          fn -> "Bob" end
        )

      assert values[:first_name] == "Jill"
    end
  end

  describe "from_struct/1" do
    test "returns a nested map" do
      value = %Person{
        name: "Bill",
        address: %Address{street: "123 Main Street", zip_code: "32229"}
      }

      result = Flamel.Map.from_struct(value)

      assert %{
               name: "Bill",
               address: %{street: "123 Main Street", zip_code: "32229"},
               dob: ""
             } == result
    end
  end
end
