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

  def unfreeze do
    Process.delete(:mock_utc_now)
    Process.delete(:current_time_mocked)
  end

  def freeze do
    Process.put(:mock_utc_now, utc_now())
    Process.put(:current_time_mocked, true)
  end

  def freeze(%DateTime{} = datetime) do
    Process.put(:mock_utc_now, datetime)
    Process.put(:current_time_mocked, true)
  end
end
