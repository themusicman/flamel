defmodule Flamel.Moment do
  @doc """
  Converts to a DateTime

  ## Examples

      iex> Flamel.Moment.to_datetime("2000-10-31T01:30:00.000-05:00")
      ~U[2000-10-31 06:30:00.000Z]

      iex> Flamel.Moment.to_datetime(~N[2019-10-31 23:00:07])
      ~N[2019-10-31 23:00:07]

      iex> {:ok, datetime} = DateTime.new(~D[2016-05-24], ~T[13:26:08.003], "Etc/UTC")
      iex> Flamel.Moment.to_datetime(datetime)
      ~U[2016-05-24 13:26:08.003Z]      

      iex> Flamel.Moment.to_datetime(nil)
      nil

      iex> Flamel.Moment.to_datetime("badstring")
      nil
  """
  def to_datetime(datetime) when is_binary(datetime) do
    case DateTime.from_iso8601(datetime) do
      {:ok, start, _} ->
        start

      _ ->
        nil
    end
  end

  def to_datetime(%DateTime{} = datetime) do
    datetime
  end

  def to_datetime(%NaiveDateTime{} = datetime) do
    datetime
  end

  def to_datetime(_) do
    nil
  end

  @doc """
  Converts to a Date

  ## Examples

      iex> Flamel.Moment.to_date(~D[2000-10-31])
      ~D[2000-10-31]

      iex> Flamel.Moment.to_date(%{"day" => "01", "month" => "12", "year" => "2004"})
      ~D[2004-12-01]

      iex> Flamel.Moment.to_date("2000-10-31")
      ~D[2000-10-31]

      iex> Flamel.Moment.to_date("2000-31-12")
      nil

      iex> Flamel.Moment.to_date(nil)
      nil
  """
  def to_date(%{"day" => day, "month" => month, "year" => year}) do
    case Date.new(
           Flamel.to_integer(year),
           Flamel.to_integer(month),
           Flamel.to_integer(day)
         ) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  def to_date(%Date{} = value) do
    value
  end

  def to_date(value) when is_binary(value) do
    case Date.from_iso8601(value) do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  def to_date(_) do
    nil
  end

  @doc """
  Converts to a DateTime

  ## Examples

      iex> Flamel.Moment.to_iso8601(~U[2000-10-31 06:30:00.000Z])
      "2000-10-31T06:30:00.000Z"

      iex> Flamel.Moment.to_iso8601(~N[2019-10-31 23:00:07])
      "2019-10-31T23:00:07"

      iex> Flamel.Moment.to_iso8601(~D[2019-10-31])
      "2019-10-31"
      
  """
  def to_iso8601(%DateTime{} = datetime) do
    DateTime.to_iso8601(datetime)
  end

  def to_iso8601(%NaiveDateTime{} = datetime) do
    NaiveDateTime.to_iso8601(datetime)
  end

  def to_iso8601(%Date{} = date) do
    Date.to_iso8601(date)
  end

  def to_iso8601(_) do
    ""
  end
end
