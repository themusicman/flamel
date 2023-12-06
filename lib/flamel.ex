defmodule Flamel do
  @moduledoc """
  Documentation for `Flamel`.
  """

  @doc """
  Turn an exception into an error tuple. This can be used with `with` to
  catch exceptions and turn them into error tuples.


  ## Examples

      iex> Flamel.try_and_return(fn -> :ok end)
      :ok

      iex> Flamel.try_and_return(fn -> raise "error" end, {:ok, :default_value})
      {:ok, :default_value}

      iex> Flamel.try_and_return(fn -> raise "error" end)
      {:error, "error"}
  """
  @spec try_and_return(fun(), any()) :: any() | {:error, binary()}
  def try_and_return(callable, ret \\ nil) do
    try do
      callable.()
    rescue
      e ->
        if ret, do: ret, else: {:error, e.message}
    end
  end

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
  Checks if something is blank?

  ## Examples

      iex> Flamel.blank?(nil)
      true

      iex> Flamel.blank?("hello world")
      false

      iex> Flamel.blank?(%{})
      true

      iex> Flamel.blank?(%{active: true})
      false

      iex> Flamel.blank?([])
      true

      iex> Flamel.blank?(["one"])
      false

      iex> Flamel.blank?("   \t   ")
      true

      iex> Flamel.blank?(0)
      false

      iex> Flamel.blank?(1)
      false
  """
  def blank?(nil), do: true
  def blank?(str) when is_binary(str), do: String.trim(str) == ""
  def blank?([]), do: true
  def blank?(map) when map == %{}, do: true
  def blank?(integer) when is_integer(integer), do: false
  def blank?(float) when is_float(float), do: false
  def blank?(%DateTime{}), do: false
  def blank?(_), do: false

  @doc """
  Checks if something is present?

  ## Examples

      iex> Flamel.present?(nil)
      false

      iex> Flamel.present?("hello world")
      true

      iex> Flamel.present?(%{})
      false

      iex> Flamel.present?(%{active: true})
      true

      iex> Flamel.present?([])
      false

      iex> Flamel.present?(["one"])
      true

      iex> Flamel.present?("   \t   ")
      false

      iex> Flamel.present?(0)
      true

      iex> Flamel.present?(1)
      true
  """
  def present?(value), do: !blank?(value)

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
  Converts to a Date

  ## Examples

      iex> Flamel.to_date(~D[2000-10-31])
      ~D[2000-10-31]

      iex> Flamel.to_date(%{"day" => "01", "month" => "12", "year" => "2004"})
      ~D[2004-12-01]

      iex> Flamel.to_date("2000-10-31")
      ~D[2000-10-31]

      iex> Flamel.to_date("2000-31-12")
      nil

      iex> Flamel.to_date(nil)
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
