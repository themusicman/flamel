defmodule Flamel.Moment.CurrentTime.Real do
  @moduledoc """
  Get the actual system time (as opposed to mocked, test time).
  """
  def timestamp do
    :os.system_time(:second)
  end

  def utc_now do
    DateTime.utc_now()
  end
end
