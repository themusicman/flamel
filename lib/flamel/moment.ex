defprotocol Flamel.Moment do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Moment` protocol is responsible for
  converting a structure to a DateTime, Date, or ISO8601 string (only if applicable).

  """

  @doc """
  Converts `term` to a DateTime.
  """
  @spec to_datetime(t) :: DateTime.t() | nil
  def to_datetime(value)

  @doc """
  Converts `term` to a Date 
  """
  @spec to_date(t) :: Date.t() | nil
  def to_date(value)

  @doc """
  Converts `term` to an ISO8601 string.
  """
  @spec to_iso8601(t) :: String.t() | nil
  def to_iso8601(value)
end

defimpl Flamel.Moment, for: Any do
  def to_datetime(_) do
    nil
  end

  def to_date(_) do
    nil
  end

  def to_iso8601(_) do
    nil
  end
end

defimpl Flamel.Moment, for: DateTime do
  def to_datetime(value) do
    value
  end

  def to_date(value) do
    DateTime.to_date(value)
  end

  def to_iso8601(value) do
    DateTime.to_iso8601(value)
  end
end

defimpl Flamel.Moment, for: NaiveDateTime do
  def to_datetime(value) do
    value
  end

  def to_date(value) do
    NaiveDateTime.to_date(value)
  end

  def to_iso8601(value) do
    NaiveDateTime.to_iso8601(value)
  end
end

defimpl Flamel.Moment, for: Date do
  def to_datetime(value) do
    (Date.to_iso8601(value) <> "T00:00:00Z")
    |> DateTime.from_iso8601()
    |> case do
      {:ok, datetime, _} -> datetime
      _ -> nil
    end
  end

  def to_date(value) do
    value
  end

  def to_iso8601(value) do
    Date.to_iso8601(value)
  end
end

defimpl Flamel.Moment, for: BitString do
  def to_datetime(value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _} ->
        datetime

      _ ->
        nil
    end
  end

  def to_datetime(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a string"
  end

  def to_date(value) when is_binary(value) do
    case Date.from_iso8601(value) do
      {:ok, date} ->
        date

      _ ->
        nil
    end
  end

  def to_date(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a string"
  end

  def to_iso8601(value) when is_binary(value) do
    case Flamel.Moment.to_datetime(value) do
      nil ->
        nil

      _ ->
        value
    end
  end

  def to_iso8601(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a string"
  end
end
