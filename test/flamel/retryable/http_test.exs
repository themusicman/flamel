defmodule Flamel.Retryable.HttpTest do
  use ExUnit.Case

  doctest Flamel.Retryable.Http

  describe "calc/1 with Flamel.Retryable.Http" do
    test "returns an exponential interval" do
      strategy = Flamel.Retryable.http()

      assert strategy.attempt == 1
      assert strategy.interval == 0
      assert strategy.max_attempts == 5
      assert strategy.with_jitter? == false
      assert strategy.multiplier == 2

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 1

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 2

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 4
      assert strategy.interval == 4

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 5
      assert strategy.interval == 8

      assert {:stop, %Flamel.Retryable.Http{attempt: 5, max_attempts: 5, interval: 8, multiplier: 2}} ==
               Flamel.Retryable.calc(strategy)
    end

    test "returns an exponential interval for infinity but obeys the max_interval" do
      strategy = Flamel.Retryable.http(max_attempts: :infinity)

      assert strategy.attempt == 1
      assert strategy.interval == 0
      assert strategy.max_attempts == :infinity
      assert strategy.multiplier == 2

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 2
      assert strategy.interval == 1

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 3
      assert strategy.interval == 2

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 4
      assert strategy.interval == 4

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 5
      assert strategy.interval == 8

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 6
      assert strategy.interval == 8

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      assert strategy.attempt == 7
      assert strategy.interval == 8
    end

    test "returns an exponential interval with jitter" do
      strategy = Flamel.Retryable.http(with_jitter?: true)

      assert strategy.attempt == 1
      assert strategy.interval == 0
      assert strategy.max_attempts == 5
      assert strategy.with_jitter? == true
      assert strategy.multiplier == 2

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 1 + max_random
      min = 1 - max_random

      assert strategy.interval in min..max

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 2 + max_random
      min = 2 - max_random

      assert strategy.interval in min..max

      {:retry, strategy} = Flamel.Retryable.calc(strategy)

      max_random = trunc(strategy.max_interval * 0.25)
      max = 4 + max_random
      min = 4 - max_random

      assert strategy.interval in min..max
    end
  end
end
