defmodule Flamel.Retry do
  @moduledoc """
  Documentation for `Flamel.Retry`.
  """

  require Logger

  @typedoc "The number of microseconds the next retry should happen in"
  @type interval() :: timeout()

  @doc """
  Calculate a retry interval

  ## Examples

      iex> Flamel.Retry.calc()
      0

  """
  def calc(strategy) do
    Flamel.Retry.Strategy.calc(strategy)
  end

  def exponential(args \\ []) do
    struct!(Flamel.Retry.Exponential, args)
  end

  def http(args \\ []) do
    struct!(Flamel.Retry.Http, args)
  end

  @spec try(term(), function()) :: term()
  def try(backoff, func) do
    execute({:try, backoff}, func)
  end

  defp execute({:stop, backoff}, _func) do
    {:error, "", backoff}
  end

  defp execute({operation, backoff}, func) when operation in [:try, :retry] do
    # turtles all the way down
    task =
      Flamel.Task.delay(
        backoff.interval,
        fn ->
          Flamel.try_and_return(fn ->
            func.(backoff)
          end)
        end
      )

    case Task.await(task) do
      {:ok, result} ->
        {:ok, result, backoff}

      error ->
        Logger.error("#{__MODULE__}.execute error=#{inspect(error)}")
        execute(Flamel.Retry.calc(backoff), func)
    end
  end
end
