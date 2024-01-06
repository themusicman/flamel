defmodule Flamel.Retry.Exponential do
  @typedoc """
  Exponential
  """
  @type t :: %__MODULE__{
          attempt: integer(),
          max_attempts: integer(),
          multiplier: integer(),
          interval: Flamel.Retry.interval(),
          max_interval: Flamel.Retry.interval(),
          base: integer(),
          with_jitter?: boolean()
        }
  defstruct attempt: 1,
            max_attempts: 5,
            multiplier: 2,
            interval: 0,
            base: 1,
            max_interval: 8,
            with_jitter?: false
end

defimpl Flamel.Retry.Strategy, for: Flamel.Retry.Exponential do
  @doc """
  Calculates a backoff interval that is a exponential value
  """
  def calc(strategy) do
    if strategy.attempt == strategy.max_attempts do
      {:stop, strategy}
    else
      strategy =
        strategy
        |> update_interval()
        |> increment()

      {:retry, strategy}
    end
  end

  def increment(strategy) do
    %{strategy | attempt: strategy.attempt + 1}
  end

  defp calculate_interval(strategy) do
    strategy.base * strategy.multiplier ** (strategy.attempt - 1)
  end

  defp calculate_randomness(%{with_jitter?: true, max_interval: max_interval}) do
    max = trunc(max_interval * 0.25)
    Enum.random(0..max)
  end

  defp calculate_randomness(_) do
    0
  end

  defp update_interval(%{max_attempts: max_attempts, attempt: attempt} = strategy)
       when attempt == max_attempts do
    strategy
  end

  defp update_interval(strategy) do
    randomness = calculate_randomness(strategy)

    interval =
      case Enum.random([:plus, :minus]) do
        :plus ->
          calculate_interval(strategy) + randomness

        :minus ->
          calculate_interval(strategy) - randomness
      end
      |> then(fn
        interval when interval < 0 ->
          0

        interval when interval > strategy.max_interval ->
          strategy.max_interval

        interval ->
          interval
      end)

    interval =
      Enum.min([
        interval,
        strategy.max_interval
      ])

    struct!(strategy, interval: interval)
  end
end
