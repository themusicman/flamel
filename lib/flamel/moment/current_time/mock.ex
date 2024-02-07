defmodule Flamel.Moment.CurrentTime.Mock do
  @moduledoc """
  Mock for current time
  """

  def utc_now do
    Process.get(:mock_utc_now) || DateTime.utc_now()
  end

  def timestamp do
    utc_now() |> DateTime.to_unix(:second)
  end
end
