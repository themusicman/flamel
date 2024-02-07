defmodule Flamel.Moment.CurrentTime do
  @moduledoc """
  Functions to get the current timestamp or DateTime - either real or mocked. These functions
  are intended to be used by your application code.
  """
  alias __MODULE__

  @doc """
  Mock the current time to the specified time for the duration of the given block. This only freezes the current time for the process it is called in.
  """
  defmacro time_travel(to, do: block) do
    quote do
      # freeze the clock at the specified time
      CurrentTime.freeze(unquote(to))
      # run the test block
      result = unquote(block)
      # go back to system time
      CurrentTime.unfreeze()
      result
    end
  end

  @doc """
  Unfreeze the current time
  """
  def unfreeze do
    Process.delete(:flamel_mocked_utc_now)
    Process.delete(:flamel_current_time_mocked)
  end

  @doc """
  Freeze the current time. This only freezes the current time for the process it is called in.
  """
  def freeze do
    Process.put(:flamel_mocked_utc_now, utc_now())
    Process.put(:flamel_current_time_mocked, true)
  end

  def freeze(%DateTime{} = datetime) do
    Process.put(:flamel_mocked_utc_now, datetime)
    Process.put(:flamel_current_time_mocked, true)
  end

  @doc """
  Return true if the current time is mocked
  """
  def mocked? do
    Process.get(:flamel_current_time_mocked) == true
  end

  @doc """
  Returns either the real current timestamp or a mocked current timestamp

  To mock the current timestamp use the `Flamel.Moment.CurrentTime.time_travel` function.
  """
  def timestamp do
    utc_now() |> DateTime.to_unix(:second)
  end

  @doc """
  Returns either the real current DateTime.utc_now() or a mocked current DateTime

  To mock the current utc_now use the `Flamel.Moment.CurrentTime.time_travel` function.
  """
  def utc_now do
    if mocked?() do
      Process.get(:flamel_mocked_utc_now) || DateTime.utc_now()
    else
      DateTime.utc_now()
    end
  end
end
