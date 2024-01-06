defmodule Flamel.Task do
  @doc """
  Execute a function after a specified delay interval.

  ## Examples

      ie> task = Flamel.Task.delay(1_000, fn -> IO.puts("I am 1 second delayed") end)
      ie> Task.await(task)
  """
  @spec delay(timeout(), function()) :: Task.t()
  def delay(interval, func) do
    Task.async(fn ->
      Process.sleep(interval)
      func.()
    end)
  end
end
