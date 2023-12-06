defmodule Flamel.MapTest do
  use ExUnit.Case
  doctest Flamel.Map
  import ExUnit.CaptureLog

  defmodule Person do
    defstruct name: "", dob: ""
  end

  alias Person

  describe "safely_get/3 when passed a field" do
    test "returns the value for that field" do
      person = %Person{name: "Karen"}

      assert Flamel.Map.safely_get(person, :name, nil) == "Karen"
    end

    test "returns the default value if the field does not exist" do
      person = %Person{name: "Karen"}

      assert Flamel.Map.safely_get(person, :type, :vocal) == :vocal
    end

    test "returns the default value if the struct is nil" do
      assert Flamel.Map.safely_get(nil, :name, "name") == "name"
    end
  end

  describe "safely_get/3 when passed a function" do
    test "returns default when KeyError" do
      assert capture_log(fn ->
               assert Flamel.Map.safely_get(
                        DateTime.now!("Etc/UTC"),
                        &String.upcase(&1.bad_key),
                        "n/a"
                      ) == "n/a"
             end) =~ "KeyError"
    end

    test "returns value that is returned from the function" do
      assert Flamel.Map.safely_get(%Person{name: "Todd"}, &String.upcase(&1.name)) == "TODD"
    end
  end

  describe "safely_get/3 when passed a function as a default value" do
    test "returns default when default is a function" do
      assert Flamel.Map.safely_get(DateTime.now!("Etc/UTC"), :missing_key, fn _dt ->
               "default from function"
             end) == "default from function"
    end
  end

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
