defmodule Flamel.Retry.ExponentialTest do
  use ExUnit.Case
  doctest Flamel.Retry.Exponential

  describe "calc/1 with Flamel.Retry.Exponential" do
    test "returns an exponential interval" do
      backoff = Flamel.Retry.exponential()

      assert backoff.attempt == 1
      assert backoff.interval == 0
      assert backoff.max_attempts == 5
      assert backoff.with_jitter? == false
      assert backoff.multiplier == 2

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 2
      assert backoff.interval == 1

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 3
      assert backoff.interval == 2

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 4
      assert backoff.interval == 4

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 5
      assert backoff.interval == 8

      assert {:stop,
              %Flamel.Retry.Exponential{attempt: 5, max_attempts: 5, interval: 8, multiplier: 2}} ==
               Flamel.Retry.calc(backoff)
    end

    test "returns an exponential interval for infinity but obeys the max_interval" do
      backoff = Flamel.Retry.exponential(max_attempts: :infinity)

      assert backoff.attempt == 1
      assert backoff.interval == 0
      assert backoff.max_attempts == :infinity
      assert backoff.multiplier == 2

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 2
      assert backoff.interval == 1

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 3
      assert backoff.interval == 2

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 4
      assert backoff.interval == 4

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 5
      assert backoff.interval == 8

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 6
      assert backoff.interval == 8

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      assert backoff.attempt == 7
      assert backoff.interval == 8
    end

    test "returns an exponential interval with jitter" do
      backoff = Flamel.Retry.exponential(with_jitter?: true)

      assert backoff.attempt == 1
      assert backoff.interval == 0
      assert backoff.max_attempts == 5
      assert backoff.with_jitter? == true
      assert backoff.multiplier == 2

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      max_random = trunc(backoff.max_interval * 0.25)
      max = 1 + max_random
      min = 1 - max_random

      assert backoff.interval in min..max

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      max_random = trunc(backoff.max_interval * 0.25)
      max = 2 + max_random
      min = 2 - max_random

      assert backoff.interval in min..max

      {:retry, backoff} = Flamel.Retry.calc(backoff)

      max_random = trunc(backoff.max_interval * 0.25)
      max = 4 + max_random
      min = 4 - max_random

      assert backoff.interval in min..max
    end
  end
end
