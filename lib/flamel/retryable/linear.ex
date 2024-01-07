defmodule Flamel.Retryable.Linear do
  @typedoc """
  Linear
  """
  @type t :: %__MODULE__{
          attempt: integer(),
          max_attempts: integer(),
          interval: Flamel.Retryable.interval(),
          max_interval: Flamel.Retryable.interval(),
          base: integer(),
          with_jitter?: boolean(),
          assigns: map(),
          halt?: boolean(),
          reason: binary() | nil
        }
  defstruct attempt: 0,
            max_attempts: 5,
            interval: 0,
            base: 1_000,
            max_interval: 5_000,
            with_jitter?: false,
            assigns: %{},
            halt?: false,
            reason: nil
end

defimpl Flamel.Retryable.Strategy, for: Flamel.Retryable.Linear do
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

  defp calculate_interval(strategy) do
    strategy.base * strategy.attempt
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

defimpl Flamel.Contextable, for: Flamel.Retryable.Linear do
  alias Flamel.Retryable.Linear
  alias Flamel.Map

  def assign(%Linear{} = context, key, value) when is_atom(key) do
    Map.assign(context, :assigns, set: [{key, value}])
  end

  def assign(%Linear{} = context, map) when is_map(map) do
    Map.assign(context, :assigns, map)
  end

  def assign(%Linear{} = context, args) when is_list(args) do
    Map.assign(context, :assigns, args)
  end

  def halt!(%Linear{} = context, reason) do
    Map.assign(context, set: [halt?: true, reason: reason])
  end

  def halted?(%Linear{halt?: true}), do: true
  def halted?(_), do: false

  def resume!(%Linear{} = context) do
    Map.assign(context, set: [halt?: false, reason: nil])
  end
end
