defmodule Backoff.Task do
  @doc """
  Run a task after a specified delay interval.

  ## Examples

      ie> task = Backoff.Task.delay(1_000, fn -> IO.puts("I am 1 second delayed") end)
      ie> Task.await(task)
  """
  @spec delay(Backoff.interval(), function()) :: Task.t()
  def delay(interval, func) do
    Task.async(fn ->
      Process.sleep(interval)
      func.()
    end)
  end
end
