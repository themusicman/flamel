defmodule Flamel.Moment.CurrentTime do
  @moduledoc """
  Functions to get the current timestamp or DateTime - either real or mocked. These functions
  are intended to be used by your application code.
  """

  alias Flamel.Moment.CurrentTime.{Real, Mock}

  defp get_impl() do
    if mocked?(), do: Mock, else: Real
  end

  defmacro time_travel(to, do: block) do
    quote do
      # freeze the clock at the specified time
      Mock.freeze(unquote(to))
      # run the test block
      result = unquote(block)
      # go back to system time
      Mock.unfreeze()
      result
    end
  end

  @doc """
  Return true if the current time is mocked
  """
  def mocked? do
    Process.get(:current_time_mocked) == true
  end

  @doc """
  Returns either the real current timestamp or a mocked current timestamp

  To mock the current timestamp use the `Flamel.Moment.CurrentTime.time_travel` function.
  """
  def timestamp do
    get_impl().timestamp()
  end

  @doc """
  Returns either the real current DateTime.utc_now() or a mocked current DateTime

  To mock the current utc_now use the `Flamel.Moment.CurrentTime.time_travel` function.
  """
  def utc_now do
    get_impl().utc_now()
  end
end
