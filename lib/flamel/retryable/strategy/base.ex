defmodule Flamel.Retryable.Strategy.Base do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      import Flamel.Context

      @doc """
      Calculates a retry interval that is a exponential value
      """
      def calc(strategy) do
        strategy =
          strategy
          |> increment()
          |> update_interval()

        if strategy.attempt == strategy.max_attempts do
          halt!(strategy, "max_attempts=#{inspect(strategy.max_attempts)} reached")
        else
          strategy
        end
      end

      def increment(strategy) do
        %{strategy | attempt: strategy.attempt + 1}
      end

      defp calculate_randomness(%{with_jitter?: true, max_interval: max_interval}) do
        max = trunc(max_interval * 0.25)
        Enum.random(0..max)
      end

      defp calculate_randomness(_) do
        0
      end

      defp update_interval(%{max_attempts: max_attempts, attempt: attempt} = strategy) when attempt == max_attempts do
        strategy
      end

      defp update_interval(strategy) do
        randomness = calculate_randomness(strategy)

        case_result =
          case Enum.random([:plus, :minus]) do
            :plus ->
              calculate_interval(strategy) + randomness

            :minus ->
              calculate_interval(strategy) - randomness
          end

        interval =
          then(case_result, fn
            interval when interval < 0 -> 0
            interval when interval > strategy.max_interval -> strategy.max_interval
            interval -> interval
          end)

        interval =
          Enum.min([
            interval,
            strategy.max_interval
          ])

        struct!(strategy, interval: interval)
      end
    end
  end
end
