defmodule Flamel.Retryable.Linear do
  @moduledoc """
  The linear retry strategy is a straightforward method for retrying failed requests by increasing the delay between retries in a linear fashion. This involves adding a fixed amount of time to the delay after each retry attempt.

  #### Key Features:
  - **Linear Increase**: Delay between retries increases linearly.
  - **Fixed Factor**: A constant value used to increase the delay.
  - **Simple Implementation**: Easy to implement and configure.
  - **Suitable for Low-Failure-Rate Systems**: Effective when the failure rate is low and the system can tolerate small delays.

  #### Example:
  - **Initial Delay**: 1 second
  - **Factor**: 2

  | Retry Attempt | Delay        |
  |---------------|--------------|
  | Retry 1       | 1 second     |
  | Retry 2       | 2 seconds    |
  | Retry 3       | 4 seconds    |
  | ...           | ...          |

  #### Advantages:
  - **Simplicity**: Easy to understand and implement.
  - **Effectiveness**: Works well for systems with a low failure rate.

  #### Disadvantages:
  - **High Failure Rates**: May not be suitable for systems with high failure rates.
  - **Excessive Delays**: Can lead to long delays if the failure rate is high.
  - **Latency Requirements**: Not ideal for systems requiring strict latency controls.
  """
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
  use Flamel.Retryable.Strategy.Base

  defp calculate_interval(strategy) do
    strategy.base * strategy.attempt
  end
end

defimpl Flamel.Contextable, for: Flamel.Retryable.Linear do
  use Flamel.Contextable.Base
end
