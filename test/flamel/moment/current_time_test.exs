defmodule Flamel.Moment.CurrentTimeTest do
  use ExUnit.Case
  alias Flamel.Moment.CurrentTime
  alias Flamel.Moment.CurrentTime.Mock
  require Flamel.Moment.CurrentTime

  describe "mocked?/0" do
    test "returns true if current time is mocked" do
      Mock.freeze()
      assert CurrentTime.mocked?() == true
    end

    test "returns false if current time is not mocked" do
      assert CurrentTime.mocked?() == false
    end
  end

  describe "utc_now/0" do
    test "returns mocked utc_now" do
      now = DateTime.utc_now() |> DateTime.add(3600, :second)

      Mock.freeze(now)

      assert CurrentTime.utc_now() == now
      assert DateTime.compare(CurrentTime.utc_now(), DateTime.utc_now()) != :eq
    end

    test "returns real utc_now" do
      current_now = CurrentTime.utc_now() |> DateTime.truncate(:second)
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      assert DateTime.compare(current_now, now) == :eq
    end
  end

  describe "time_travel/2" do
    test "mocks the current time based on the value given" do
      to = DateTime.utc_now() |> DateTime.add(3600, :second)

      CurrentTime.time_travel to do
        assert CurrentTime.utc_now() == to
        assert DateTime.compare(CurrentTime.utc_now(), DateTime.utc_now()) != :eq
      end
    end
  end
end
