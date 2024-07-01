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
    callable.()
  rescue
    e ->
      if ret, do: ret, else: {:error, e.message}
  end

  defdelegate unwrap_ok!(value), to: Flamel.Wrap
  defdelegate unwrap_error!(value), to: Flamel.Wrap
  defdelegate unwrap_ok_or_nil(value), to: Flamel.Wrap
  defdelegate unwrap_error_or_nil(value), to: Flamel.Wrap
  defdelegate unwrap(value), to: Flamel.Wrap
  defdelegate ok?(value), to: Flamel.Wrap
  defdelegate error?(value), to: Flamel.Wrap

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

      iex> Flamel.blank?(true)
      false

      iex> Flamel.blank?(false)
      false
  """
  def blank?(value) do
    Flamel.Blank.blank?(value)
  end

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
  def present?(value), do: !Flamel.Blank.blank?(value)

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
  Is this a DateTime

  ## Examples

      iex> Flamel.datetime?(true)
      false

      iex> Flamel.datetime?(~U[2021-12-21 18:27:00Z])
      true

      iex> Flamel.datetime?("2021-12-21T18:27:00Z")
      true
  """
  def datetime?(value) do
    Flamel.Moment.to_datetime(value) != nil
  end

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

      iex> Flamel.to_boolean("TRUE")
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
  def to_boolean(value) do
    Flamel.Boolean.to(value)
  end

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
  def to_string(value) do
    Flamel.String.to(value)
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

  def to_atom(value) do
    Flamel.Atom.to(value)
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
  def to_integer(value) do
    Flamel.Integer.to(value)
  end

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
  def to_float(value) do
    Flamel.Float.to(value)
  end

  @doc """
  Converts to a map
  """
  def to_map(value) do
    Flamel.Mappable.to(value)
  end
end
