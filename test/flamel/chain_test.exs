defmodule Flamel.ChainTest do
  use ExUnit.Case

  alias Flamel.Chain
  alias Flamel.Context

  doctest Flamel.Chain

  describe "new/1" do
    test "returns new chain with a value set" do
      value = 1

      chain = Chain.new(value)

      assert Chain.to_value(chain) == value
    end
  end

  defp add_one(value) do
    value + 1
  end

  describe "curry/1" do
    test "returns a anonymous function" do
      value = 1

      func = Chain.curry(fn chain -> Chain.apply(chain, &add_one/1) end)

      assert is_function(func)

      chain = func.(value)
      assert Chain.to_value(chain) == 2
    end

    test "returns a anonymous function that can be used with Enum.map/1" do
      value = [1, 2, 3]

      func =
        Chain.curry(fn chain ->
          chain |> Chain.apply(&add_one/1) |> Chain.apply(&add_one/1) |> Chain.to_value()
        end)

      chains = Enum.map(value, func)
      assert chains == [3, 4, 5]
    end
  end

  defp produce_error(value) do
    {:error, :bad_number, value}
  end

  defp produce_ok(value) do
    {:ok, value + 1}
  end

  describe "apply/1" do
    test "returns an error reason when the function returns an error tuple" do
      value = 1

      chain = Chain.new(value)
      chain = Chain.apply(chain, &produce_error/1)

      assert chain.reason == "bad_number"
      assert Chain.to_value(chain) == value
    end

    test "returns value when the function returns an ok tuple" do
      value = 1

      chain = Chain.new(value)
      chain = Chain.apply(chain, &produce_ok/1)

      assert chain.reason == nil
      assert Chain.to_value(chain) == value + 1
    end

    test "returns true if the chain was halted" do
      value = 1

      chain = Chain.new(value)
      chain = Chain.apply(chain, &produce_error/1)

      assert Context.halted?(chain)
    end
  end
end
