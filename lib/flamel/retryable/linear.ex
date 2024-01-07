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
  use Flamel.Retryable.Strategy.Base

  defp calculate_interval(strategy) do
    strategy.base * strategy.attempt
  end
end

defimpl Flamel.Contextable, for: Flamel.Retryable.Linear do
  use Flamel.Contextable.Base
end
