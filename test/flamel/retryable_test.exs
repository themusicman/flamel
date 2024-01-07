defmodule Flamel.RetryableTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  doctest Flamel.Retryable
  alias Flamel.Retryable
  import Flamel.Context

  describe "try/2" do
    test "returns a result when successful" do
      strategy = Retryable.linear()
      assert strategy.attempt == 0

      {:ok, result, strategy} = Retryable.try(strategy, fn _ -> {:ok, "success", strategy} end)

      assert result == "success"
      assert strategy.attempt == 0
    end

    test "returns result after one failed attempt" do
      strategy = Retryable.linear(base: 1)
      assert strategy.attempt == 0

      assert capture_log(fn ->
               {:ok, result, strategy} =
                 Retryable.try(strategy, fn strategy ->
                   if strategy.attempt == 0 do
                     {:error}
                   else
                     {:ok, "success", strategy}
                   end
                 end)

               assert result == "success"
               assert strategy.attempt == 1
             end) =~ "[error] Elixir.Flamel.Retryable.execute error={:error}"
    end

    test "returns result with assigns updated when success" do
      strategy = Retryable.linear(base: 1)
      assert strategy.attempt == 0

      {:ok, result, strategy} =
        Retryable.try(strategy, fn strategy ->
          {:ok, "success", assign(strategy, :hello, :world)}
        end)

      assert result == "success"
      assert strategy.assigns[:hello] == :world
    end

    test "returns error after max_attempts" do
      strategy = Retryable.linear(base: 1, max_attempts: 3)
      assert strategy.attempt == 0

      assert capture_log(fn ->
               {:error, result, strategy} =
                 Retryable.try(strategy, fn strategy ->
                   {:error, "error", strategy}
                 end)

               assert result == nil
               assert strategy.attempt == 3
             end) =~ "[error] Elixir.Flamel.Retryable.execute error="
    end

    test "returns error after max_attempts with base of 1000" do
      strategy = Retryable.linear(base: 1_000, max_attempts: 3, max_interval: 5000)
      assert strategy.attempt == 0

      assert capture_log(fn ->
               {:error, result, strategy} =
                 Retryable.try(strategy, fn strategy ->
                   {:error, "error", strategy}
                 end)

               assert result == nil
               assert strategy.attempt == 3
             end) =~ "[error] Elixir.Flamel.Retryable.execute error="
    end
  end
end
