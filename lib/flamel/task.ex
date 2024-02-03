defmodule Flamel.Task do
  @moduledoc """
  Provides a few convenience functions for common Task use cases **Alpha**
  """

  @doc """
  Execute a function after a specified delay interval. **Alpha**

  ## Examples

      ie> task = Flamel.Task.delay(1_000, fn -> IO.puts("I am 1 second delayed") end)
  """
  @spec delay(timeout(), function()) :: term()
  def delay(interval, func) do
    Flamel.Task.async(
      func,
      delay: interval
    )
  end

  @doc """
  Execute a function asynchronously **Alpha**

  ## Examples

      ie> task = Flamel.Task.async(fn -> IO.puts("Look at me!") end)
  """
  @spec async(function(), keyword()) :: term()
  def async(func, opts \\ []) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "background/2 expected a keyword list, got: #{inspect(opts)}"
    end

    shutdown_timeout = Keyword.get(opts, :shutdown_timeout, 5_000)
    supervisor = Keyword.get(opts, :supervisor, __MODULE__)
    delay = Keyword.get(opts, :delay, nil)

    Task.Supervisor.async(
      supervisor,
      fn ->
        if delay, do: Process.sleep(delay)
        func.()
      end,
      restart: :transient,
      shutdown: shutdown_timeout
    )
    |> Task.await()
  end

  @doc """
  Execute a stream asynchronously **Alpha**

  ## Examples

      ie> task = Flamel.Task.stream(["one", "two"], fn item -> IO.puts(item) end)
  """
  @spec stream(function(), keyword()) :: [term()]
  def stream(stream, func, opts \\ []) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "stream/2 expected a keyword list, got: #{inspect(opts)}"
    end

    shutdown_timeout = Keyword.get(opts, :shutdown_timeout, 5_000)
    supervisor = Keyword.get(opts, :supervisor, __MODULE__)

    Task.Supervisor.async_stream(
      supervisor,
      stream,
      fn item ->
        func.(item)
      end,
      restart: :transient,
      shutdown: shutdown_timeout
    )
    |> Enum.to_list()
  end

  @doc """
  Executes a task in a background process **Alpha**
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
