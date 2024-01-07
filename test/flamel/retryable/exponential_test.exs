defmodule Flamel.Retryable.ExponentialTest do
  use ExUnit.Case
  doctest Flamel.Retryable.Exponential

  describe "calc/1 with Flamel.Retryable.Exponential" do
    test "returns an exponential interval" do
      strategy = Flamel.Retryable.exponential()

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == 5
      assert strategy.with_jitter? == false
      assert strategy.multiplier == 2

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 1
      assert strategy.interval == 1_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 2_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 4_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 4
      assert strategy.interval == 8_000

      assert %Flamel.Retryable.Exponential{
               attempt: 5,
               max_attempts: 5,
               interval: 8_000,
               multiplier: 2,
               halt: true,
               reason: "max_attempts=5 reached"
             } ==
               Flamel.Retryable.calc(strategy)
    end

    test "returns an exponential interval for infinity but obeys the max_interval" do
      strategy = Flamel.Retryable.exponential(max_attempts: :infinity)

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == :infinity
      assert strategy.multiplier == 2

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 1
      assert strategy.interval == 1_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 2_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 4_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 4
      assert strategy.interval == 8_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 5
      assert strategy.interval == 8_000

      strategy = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 6
      assert strategy.interval == 8_000
    end

    test "returns an exponential interval with jitter" do
      strategy = Flamel.Retryable.exponential(with_jitter?: true)

      assert strategy.attempt == 0
      assert strategy.interval == 0
      assert strategy.max_attempts == 5
      assert strategy.with_jitter? == true
      assert strategy.multiplier == 2

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

      strategy = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 4_000 + max_random
      min = 4_000 - max_random

      assert strategy.interval in min..max
    end
  end

  describe "assign/3" do
    test "returns strategy with a value in the assigns" do
      import Flamel.Context

      strategy = Flamel.Retryable.exponential()
      strategy = assign(strategy, :hello, :world)
      assert strategy.assigns[:hello] == :world
    end

    test "can halt context" do
      import Flamel.Context

      strategy = Flamel.Retryable.exponential()
      assert strategy.halt == false
      strategy = halt!(strategy, "reason")
      assert strategy.halt == true
    end

    test "can resume context" do
      import Flamel.Context

      strategy = Flamel.Retryable.exponential(halt: true)
      assert strategy.halt == true
      strategy = resume!(strategy)
      assert strategy.halt == false
    end
  end
end
