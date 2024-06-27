defmodule Flamel.Retryable.Exponential do
  @moduledoc """
  ### Exponential Backoff Strategy Documentation

  The exponential backoff strategy is a method for retrying failed requests by exponentially increasing the delay between retries. This approach involves doubling the delay time after each failed attempt, which helps to reduce the load on the system and provides time for the issue causing the failure to resolve.

  #### Key Features:
  - **Exponential Increase**: Delay between retries increases exponentially.
  - **Doubling Factor**: Each retry delay is double the previous delay.
  - **Effective for High-Failure-Rate Systems**: Helps manage retries when failure rates are high.
  - **Adaptable Delay**: Delay increases quickly, reducing the number of retries over time.

  #### Example:
  - **Initial Delay**: 1 second

  | Retry Attempt | Delay        |
  |---------------|--------------|
  | Retry 1       | 1 second     |
  | Retry 2       | 2 seconds    |
  | Retry 3       | 4 seconds    |
  | Retry 4       | 8 seconds    |
  | ...           | ...          |

  #### Advantages:
  - **Reduces Load**: Helps to reduce system load by spacing out retries.
  - **Adapts to Failure Rates**: Quickly adapts to high failure rates by increasing delays.
  - **Prevents Immediate Retries**: Reduces the chance of immediate repeated failures.

  #### Disadvantages:
  - **Complexity**: More complex to implement compared to linear strategies.
  - **Long Delays**: Can lead to very long delays if retries continue to fail.
  - **Latency Impact**: Not suitable for systems with strict latency requirements due to increasing delays.
  """
  @typedoc """
  Exponential
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
          halt?: boolean(),
          reason: binary() | nil
        }
  defstruct attempt: 0,
            max_attempts: 5,
            multiplier: 2,
            interval: 0,
            base: 1_000,
            max_interval: 8_000,
            with_jitter?: false,
            assigns: %{},
            halt?: false,
            reason: nil
end

defimpl Flamel.Retryable.Strategy, for: Flamel.Retryable.Exponential do
  use Flamel.Retryable.Strategy.Base

  defp calculate_interval(strategy) do
    cond do
      strategy.attempt == 1 ->
        strategy.base

      strategy.attempt == 2 ->
        strategy.base * strategy.attempt

      true ->
        strategy.base * strategy.multiplier ** (strategy.attempt - 1)
    end
  end
end

defimpl Flamel.Contextable, for: Flamel.Retryable.Exponential do
  use Flamel.Contextable.Base
end
