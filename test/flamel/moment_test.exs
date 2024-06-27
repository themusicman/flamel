defmodule Flamel.MomentTest do
  use ExUnit.Case

  doctest Flamel.Moment

  describe "to_datetime/1" do
    test "return a DateTime for a valid ISO8601 string" do
      datetime = ~U[2021-12-21 18:27:00Z]
      iso8601 = DateTime.to_iso8601(datetime)
      value = Flamel.Moment.to_datetime(iso8601)
      assert value == datetime
    end

    test "returns nil for invalid ISO8601 string" do
      value = Flamel.Moment.to_datetime("badstring")
      assert value == nil
    end

    test "returns a DateTime for a Date" do
      date = ~D[2021-12-21]
      value = Flamel.Moment.to_datetime(date)
      assert value == ~U[2021-12-21 00:00:00Z]
    end

    test "returns nil for any invalid type" do
      assert Flamel.Moment.to_datetime(nil) == nil
    end
  end

  describe "to_iso8601/1" do
    test "return ISO8601 string for a valid ISO8601 string" do
      iso8601 = DateTime.to_iso8601(~U[2021-12-21 18:27:00Z])
      value = Flamel.Moment.to_iso8601(iso8601)
      assert value == iso8601
    end

    test "returns nil for invalid ISO8601 string" do
      value = Flamel.Moment.to_iso8601("badstring")
      assert value == nil
    end

    test "returns a ISO8601 string for a Date" do
      date = ~D[2021-12-21]
      value = Flamel.Moment.to_iso8601(date)
      assert value == Date.to_iso8601(date)
    end

    test "returns nil for any invalid type" do
      assert Flamel.Moment.to_iso8601(nil) == nil
    end
  end

  describe "to_date/1" do
    test "returns a Date for a valid ISO8601 string" do
      date = ~D[2021-12-21]
      iso8601 = Date.to_iso8601(date)
      value = Flamel.Moment.to_date(iso8601)
      assert value == date
    end

    test "returns a Date for a Date" do
      date = ~D[2021-12-21]
      value = Flamel.Moment.to_date(date)
      assert value == date
    end

    test "returns nil for any invalid type" do
      assert Flamel.Moment.to_date(nil) == nil
    end
  end
end
