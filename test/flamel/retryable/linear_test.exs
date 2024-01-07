defmodule Flamel.Retryable.LinearTest do
  use ExUnit.Case
  doctest Flamel.Retryable.Linear

  describe "calc/1 with Flamel.Retryable.Linear" do
    test "returns an linear interval" do
      strategy = Flamel.Retryable.linear(max_attempts: 4)

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == 4
      assert strategy.with_jitter? == false

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 1
      assert strategy.interval == 1_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 2_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 3_000

      assert %Flamel.Retryable.Linear{
               attempt: 4,
               max_attempts: 4,
               interval: 3_000,
               reason: "max_attempts=4 reached",
               halt?: true
             } ==
               Flamel.Retryable.calc(strategy)
    end

    test "returns an linear interval for infinity but obeys the max_interval" do
      strategy = Flamel.Retryable.linear(max_attempts: :infinity)

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == :infinity

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 1
      assert strategy.interval == 1_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 2_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 3_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 4
      assert strategy.interval == 4_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 5
      assert strategy.interval == 5_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 6
      assert strategy.interval == 5_000
    end

    test "returns an linear interval with jitter" do
      strategy = Flamel.Retryable.linear(max_attempts: 3, with_jitter?: true)

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == 3
      assert strategy.with_jitter? == true

      strategy = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 1_000 + max_random
      min = 1_000 - max_random

      assert strategy.interval in min..max

      strategy = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 2_000 + max_random
      min = 2_000 - max_random

      assert strategy.interval in min..max
    end
  end

  describe "assign/3" do
    test "returns strategy with a value in the assigns" do
      import Flamel.Context

      strategy = Flamel.Retryable.linear()
      strategy = assign(strategy, :hello, :world)
      assert strategy.assigns[:hello] == :world
    end

    test "can halt? context" do
      import Flamel.Context

      strategy = Flamel.Retryable.linear()
      assert strategy.halt? == false
      strategy = halt!(strategy, "reason")
      assert strategy.halt? == true
    end

    test "can resume context" do
      import Flamel.Context

      strategy = Flamel.Retryable.linear(halt?: true)
      assert strategy.halt? == true
      strategy = resume!(strategy)
      assert strategy.halt? == false
    end
  end
end
