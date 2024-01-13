defmodule Flamel.Task do
  @moduledoc """
  Provides a few convenience functions for common Task uses
  """

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

  @doc """
  Executes a task in a background process
  """
  @spec background(function()) :: term()
  def background(func, opts \\ []) when is_function(func) and is_list(opts) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "background/2 expected a keyword list, got: #{inspect(opts)}"
    end

    shutdown_timeout = Keyword.get(opts, :shutdown_timeout, 5_000)
    env = Keyword.get(opts, :env, nil)
    supervisor = Keyword.get(opts, :supervisor, __MODULE__)

    if env == :test do
      func.()
    else
      Task.Supervisor.start_child(
        supervisor,
        fn ->
          Process.flag(:trap_exit, true)

          func.()
        end,
        restart: :transient,
        shutdown: shutdown_timeout
      )
    end
  end
end
