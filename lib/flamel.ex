defmodule Flamel do
  @moduledoc """
  Documentation for `Flamel`.
  """

  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.unwrap_ok!({:ok, []})
      []

      iex> Flamel.unwrap_ok!({:error, "message"})
      ** (ArgumentError) {:error, "message"} is not an :ok tuple
  """
  def unwrap_ok!({:ok, value}) do
    value
  end

  def unwrap_ok!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :ok tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.unwrap_error!({:ok, []})
      ** (ArgumentError) {:ok, []} is not an :error tuple

      iex> Flamel.unwrap_error!({:error, "message"})
      "message"
  """
  def unwrap_error!({:error, value}) do
    value
  end

  def unwrap_error!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :error tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value or nil

  ## Examples

      iex> Flamel.unwrap_ok_or_nil({:ok, []})
      []

      iex> Flamel.unwrap_ok_or_nil({:error, "message"})
      nil
  """
  def unwrap_ok_or_nil({:ok, value}) do
    value
  end

  def unwrap_ok_or_nil(_) do
    nil
  end

  @doc """
  Takes an {:error, value} tuple and returns the value or nil 

  ## Examples

      iex> Flamel.unwrap_error_or_nil({:ok, []})
      nil

      iex> Flamel.unwrap_error_or_nil({:error, "message"})
      "message"
  """
  def unwrap_error_or_nil({:error, value}) do
    value
  end

  def unwrap_error_or_nil(_) do
    nil
  end

  @doc """
  Takes an {:ok, value} or {:error, message} tuple and returns the value

  ## Examples

      iex> Flamel.unwrap({:ok, []})
      []

      iex> Flamel.unwrap({:error, "message"})
      "message"
  """
  def unwrap({:ok, value}), do: value
  def unwrap({:error, value}), do: value

  @doc """
  Checks if something is empty?

  ## Examples

      iex> Flamel.empty?(nil)
      true

      iex> Flamel.empty?("hello world")
      false

      iex> Flamel.empty?(%{})
      true

      iex> Flamel.empty?(%{active: true})
      false

      iex> Flamel.empty?([])
      true

      iex> Flamel.empty?(["one"])
      false

      iex> Flamel.empty?("   \t   ")
      true
  """
  def empty?(nil), do: true
  def empty?(0), do: true
  def empty?(integer) when is_integer(integer), do: false
  def empty?(str) when is_binary(str), do: String.trim(str) == ""
  def empty?([]), do: true
  def empty?(map) when map == %{}, do: true
  def empty?(%DateTime{}), do: false
  def empty?(_), do: false

  @doc """
  Is something a boolean?

  ## Examples

      iex> Flamel.boolean?(true)
      true

      iex> Flamel.boolean?(false)
      true

      iex> Flamel.boolean?(nil)
      false

      iex> Flamel.boolean?("true")
      false
  """
  def boolean?(value) when is_boolean(value), do: true
  def boolean?(value) when not is_boolean(value), do: false

  @doc """
  Convert something to a boolean

  ## Examples

      iex> Flamel.to_boolean("Y")
      true

      iex> Flamel.to_boolean("y")
      true

      iex> Flamel.to_boolean("YES")
      true

      iex> Flamel.to_boolean("Yes")
      true

      iex> Flamel.to_boolean("yes")
      true

      iex> Flamel.to_boolean("true")
      true

      iex> Flamel.to_boolean(1)
      true

      iex> Flamel.to_boolean(true)
      true 

      iex> Flamel.to_boolean("N")
      false

      iex> Flamel.to_boolean("n")
      false

      iex> Flamel.to_boolean("NO")
      false

      iex> Flamel.to_boolean("No")
      false

      iex> Flamel.to_boolean("no")
      false

      iex> Flamel.to_boolean("false")
      false

      iex> Flamel.to_boolean(0)
      false

      iex> Flamel.to_boolean(false)
      false
  """
  def to_boolean("Y"), do: true
  def to_boolean("y"), do: true
  def to_boolean("YES"), do: true
  def to_boolean("Yes"), do: true
  def to_boolean("yes"), do: true
  def to_boolean("true"), do: true
  def to_boolean("1"), do: true
  def to_boolean(1), do: true
  def to_boolean(true), do: true
  def to_boolean("N"), do: false
  def to_boolean("n"), do: false
  def to_boolean("NO"), do: false
  def to_boolean("No"), do: false
  def to_boolean("no"), do: false
  def to_boolean("false"), do: false
  def to_boolean("0"), do: false
  def to_boolean(0), do: false
  def to_boolean(false), do: false
  def to_boolean(nil), do: false
  def to_boolean(_), do: false

  @doc """
  Converts to a string

  ## Examples

      iex> Flamel.to_string(nil)
      ""

      iex> Flamel.to_string("test")
      "test"

      iex> Flamel.to_string(:test)
      "test"

      iex> Flamel.to_string(2.3)
      "2.3"

      iex> Flamel.to_string(1)
      "1"

      iex> Flamel.to_string(1)
      "1"

  """
  def to_string(value) when is_binary(value) do
    value
  end

  def to_string(value) when is_integer(value) do
    Integer.to_string(value)
  end

  def to_string(value) when is_float(value) do
    Float.to_string(value)
  end

  def to_string(value) when is_nil(value) do
    ""
  end

  def to_string(value) when is_atom(value) do
    Atom.to_string(value)
  end

  def to_string(_) do
    ""
  end

  @doc """
  Converts to an atom. Warning: This uses `String.to_atom`

  ## Examples
      
      iex> Flamel.to_atom(:test)
      :test

      iex> Flamel.to_atom("test")
      :test

      iex> Flamel.to_atom(1)
      :"1"

      iex> Flamel.to_atom(1.1)
      :"1.1"
  """

  def to_atom(value) when is_binary(value) do
    String.to_atom(value)
  end

  def to_atom(value) when is_atom(value) do
    value
  end

  def to_atom(value) when is_float(value) do
    value |> Flamel.to_string() |> to_atom()
  end

  def to_atom(value) when is_integer(value) do
    value |> Flamel.to_string() |> to_atom()
  end

  def to_atom(_) do
    nil
  end

  @doc """
  Converts to an integer

  ## Examples
      
      iex> Flamel.to_integer("1")
      1

      iex> Flamel.to_integer(1)
      1

      iex> Flamel.to_integer(1.2)
      1

      iex> Flamel.to_integer(nil)
      0

  """
  def to_integer(value) when is_binary(value), do: String.to_integer(value)
  def to_integer(value) when is_integer(value), do: value
  def to_integer(value) when is_float(value), do: trunc(value)
  def to_integer(value) when is_nil(value), do: 0

  @doc """
  Converts to a float
    
  ## Examples

      iex> Flamel.to_float("1.2")
      1.2

      iex> Flamel.to_float(1.2)
      1.2

      iex> Flamel.to_float(1)
      1.0

      iex> Flamel.to_float(nil)
      0.0
  """
  def to_float(value) when is_binary(value) do
    value
    |> Float.parse()
    |> case do
      {value, _} ->
        value

      _ ->
        0.0
    end
  end

  def to_float(value) when is_float(value) do
    value
  end

  def to_float(value) when is_integer(value) do
    value
    |> Integer.to_string()
    |> to_float()
  end

  def to_float(value) when is_nil(value) do
    0.0
  end

  @doc """
  Converts to a map
  """
  def to_map(value) when is_struct(value) do
    Map.from_struct(value)
  end

  def to_map(value) when is_map(value) do
    value
  end

  @doc """
  Converts to a DateTime

  ## Examples

      iex> Flamel.to_datetime("2000-10-31T01:30:00.000-05:00")
      ~U[2000-10-31 06:30:00.000Z]

      iex> Flamel.to_datetime(~N[2019-10-31 23:00:07])
      ~N[2019-10-31 23:00:07]

      iex> {:ok, datetime} = DateTime.new(~D[2016-05-24], ~T[13:26:08.003], "Etc/UTC")
      iex> Flamel.to_datetime(datetime)
      ~U[2016-05-24 13:26:08.003Z]      

      iex> Flamel.to_datetime(nil)
      nil

      iex> Flamel.to_datetime("badstring")
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
  Converts to a DateTime

  ## Examples

      iex> Flamel.to_iso8601(~U[2000-10-31 06:30:00.000Z])
      "2000-10-31T06:30:00.000Z"

      iex> Flamel.to_iso8601(~N[2019-10-31 23:00:07])
      "2019-10-31T23:00:07"

      iex> Flamel.to_iso8601(~D[2019-10-31])
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
