defmodule Flamel.Retryable do
  @moduledoc """
  Documentation for `Flamel.Retryable`.
  """

  require Logger

  @typedoc "The number of milliseconds the next retry should happen in"
  @type interval() :: timeout()

  @doc """
  Calculate a retry interval

  """
  def calc(strategy) do
    Flamel.Retryable.Strategy.calc(strategy)
  end

  @doc """
  Create a Linear Retry Strategy

  ## Examples

      iex> Flamel.Retryable.linear(max_attempts: 10)
      %Flamel.Retryable.Linear{max_attempts: 10}
  """
  @spec linear(keyword()) :: Flamel.Retryable.Linear.t()
  def linear(args \\ []) do
    struct!(Flamel.Retryable.Linear, args)
  end

  @doc """
  Create an Exponential Retry Strategy

  ## Examples

      iex> Flamel.Retryable.exponential(multiplier: 10)
      %Flamel.Retryable.Exponential{multiplier: 10}
  """
  @spec exponential(keyword()) :: Flamel.Retryable.Exponential.t()
  def exponential(args \\ []) do
    struct!(Flamel.Retryable.Exponential, args)
  end

  @doc """
  Create an HTTP Retry Strategy.

  This strategy requires setting the HTTP status code so that
  it can adjust the retry interval based on the status.

  ## Examples

      iex> Flamel.Retryable.http(max_attempts: 10)
      %Flamel.Retryable.Http{max_attempts: 10}
  """
  @spec http(keyword()) :: Flamel.Retryable.Http.t()
  def http(args \\ []) do
    struct!(Flamel.Retryable.Http, args)
  end

  @doc """
  Executes a function based on the `Flamel.Retryable.Strategy`. The function is
  expected to return either a {:ok, result, strategy} or {:error, reason, strategy} tuple. If an error tuple is returned or an exception occurs the function will be retryed
  based on the strategy configuration.


  ## Examples

      iex> strategy = Flamel.Retryable.linear()
      iex> Flamel.Retryable.try(strategy, fn strategy -> {:ok, "success", strategy} end)
      iex> {:ok, "success", strategy}
  """

  @spec try(%{required(:halt?) => boolean()}, function()) :: term()
  def try(%{halt?: true} = strategy, _func) do
    {:error, nil, strategy}
  end

  def try(strategy, func) do
    strategy.interval
    |> Flamel.Task.delay(
      # turtles all the way down
      fn ->
        Flamel.try_and_return(fn ->
          func.(strategy)
        end)
      end
    )
    |> case do
      {:ok, result, strategy} ->
        {:ok, result, strategy}

      {:error, %{halt?: _, assigns: _} = strategy} = error ->
        Logger.error("#{__MODULE__}.execute error=#{inspect(error)}")
        try(Flamel.Retryable.calc(strategy), func)

      error ->
        Logger.error("#{__MODULE__}.execute error=#{inspect(error)}")
        try(Flamel.Retryable.calc(strategy), func)
    end
  end
end
