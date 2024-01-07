defmodule Flamel.Retryable.Exponential do
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
