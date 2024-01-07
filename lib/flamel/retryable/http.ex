defmodule Flamel.Retryable.Http do
  @typedoc """
  Http
  """
  @type t :: %__MODULE__{
          attempt: integer(),
          max_attempts: integer(),
          multiplier: integer(),
          interval: Flamel.Retryable.interval(),
          max_interval: Flamel.Retryable.interval(),
          base: integer(),
          with_jitter?: boolean(),
          assigns: map(),
          halt: boolean(),
          reason: binary() | nil
        }
  defstruct attempt: 1,
            max_attempts: 5,
            multiplier: 2,
            interval: 0,
            base: 1,
            max_interval: 8,
            with_jitter?: false,
            assigns: %{},
            halt: false,
            reason: nil
end

defimpl Flamel.Contextable, for: Flamel.Retryable.Http do
  alias Flamel.Retryable.Http

  def assign(%Http{} = context, key, value) when is_atom(key) do
    %{context | assigns: Map.put(context.assigns, key, value)}
  end

  def assign(%Http{} = context, map) when is_map(map) do
    %{context | assigns: Map.merge(context.assigns, map)}
  end

  def halt!(%Http{} = context, reason) do
    %{context | halt: true, reason: reason}
  end

  def halted?(%Http{halt: true}), do: true
  def halted?(_), do: false

  def resume!(%Http{} = context) do
    %{context | halt: false}
  end
end

defimpl Flamel.Retryable.Strategy, for: Flamel.Retryable.Http do
  @doc """
  Calculates a retry interval that is a exponential value

  Once an established connection drops, attempt to reconnect immediately. If the reconnect fails, slow down your reconnect attempts according to the type of error experienced:

  Back off linearly for TCP/IP level network errors. These problems are generally temporary and tend to clear quickly. Increase the delay in reconnects by 250ms each attempt, up to 16 seconds.

  Back off exponentially for HTTP errors for which reconnecting would be appropriate. Start with a 5 second wait, doubling each attempt, up to 320 seconds.

  Back off exponentially for HTTP 420 errors. Start with a 1 minute wait and double each attempt. Note that every HTTP 420 received increases the time you must wait until rate limiting will no longer will be in effect for your account.
  """
  def calc(strategy) do
    raise "DO NOT USE"

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
