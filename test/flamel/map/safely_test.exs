defmodule Flamel.Map.SafelyTest do
  use ExUnit.Case
  doctest Flamel.Map.Safely
  import ExUnit.CaptureLog

  defmodule Person do
    defstruct name: "", dob: ""
  end

  alias Person

  describe "get/3 when passed a field" do
    test "returns the value for that field" do
      person = %Person{name: "Karen"}

      assert Flamel.Map.Safely.get(person, :name, nil) == "Karen"
    end

    test "returns the default value if the field does not exist" do
      person = %Person{name: "Karen"}

      assert Flamel.Map.Safely.get(person, :type, :vocal) == :vocal
    end

    test "returns the default value if the struct is nil" do
      assert Flamel.Map.Safely.get(nil, :name, "name") == "name"
    end
  end

  describe "get/3 when passed a function" do
    test "returns default when KeyError" do
      assert capture_log(fn ->
               assert Flamel.Map.Safely.get(
                        DateTime.now!("Etc/UTC"),
                        &String.upcase(&1.bad_key),
                        "n/a"
                      ) == "n/a"
             end) =~ "KeyError"
    end

    test "returns value that is returned from the function" do
      assert Flamel.Map.Safely.get(%Person{name: "Todd"}, &String.upcase(&1.name)) == "TODD"
    end
  end

  describe "get/3 when passed a function as a default value" do
    test "returns default when default is a function" do
      assert Flamel.Map.Safely.get(DateTime.now!("Etc/UTC"), :missing_key, fn _dt ->
               "default from function"
             end) == "default from function"
    end
  end
end
