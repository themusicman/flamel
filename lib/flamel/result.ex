defmodule Flamel.Result do
  @moduledoc """
  Some helper functions for dealing with result tuples
  """

  import Flamel.Wrap, only: [ok: 1]

  @doc """
  Applies a function to the value of an `{:ok, value}`. The return value of the function is wrapped in an `{:ok, value}` tuple.
  If the tuple passed to map is an `{:error, reason}` tuple then the function is not applied and the `{:error, reason}` tuple is returned.

  ## Examples

      iex> Flamel.Result.map({:ok, []}, fn v -> ["test" | v] end)
      {:ok, ["test"]}

      iex> Flamel.Result.map({:error, "message"}, fn v -> ["test" | v] end)
      {:error, "message"}
  """
  @spec map(tuple(), fun()) :: tuple()
  def map({:ok, value}, func), do: value |> func.() |> ok()
  def map({:ok, value, second_value}, func), do: value |> func.(second_value) |> ok()
  def map(value, _func), do: value

  @doc """
  Essentially has the same behavior as `Flamel.Result.map/2` but the return value of the function is not automatically wrapped in an `{:ok, value}` tuple. You should return either a `{:ok, value}` tuple or `{:error, reason}` tuple from the function.
  `Flamel.Result.then/2` should be used when the function can produce an error.

  ## Examples

      iex> Flamel.Result.then({:ok, []}, fn v -> {:ok, ["test" | v]} end)
      {:ok, ["test"]}

      iex> Flamel.Result.then({:ok, []}, fn _v -> {:error, :bad_arg} end)
      {:error, :bad_arg}

      iex> Flamel.Result.then({:error, "message"}, fn v -> ["test" | v] end)
      {:error, "message"}
  """
  @spec then(tuple(), fun()) :: tuple()
  def then({:ok, value}, func), do: func.(value)
  def then({:ok, value, second_value}, func), do: func.(value, second_value)
  def then(value, _func), do: value

  @doc """
  Returns true if the value is an `:ok`, `{:ok, value}`, `{:ok, value, value}`

  ## Examples

      iex> Flamel.Result.ok?({:ok, []})
      true

      iex> Flamel.Result.ok?({:error, "message"})
      false
  """
  def ok?(:ok), do: true
  def ok?({:ok, _value}), do: true
  def ok?({:ok, _value, _second_value}), do: true
  def ok?(_), do: false

  @doc """
  Returns true if the value is an `:error`, `{:error, value}`, `{:error, value, value}`

  ## Examples

      iex> Flamel.Result.error?({:error, "error message"})
      true

      iex> Flamel.Result.error?({:ok, "message"})
      false
  """
  def error?(:error), do: true
  def error?({:error, _value}), do: true
  def error?({:error, _value, _second_value}), do: true
  def error?(_), do: false

  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.Result.ok!({:ok, []})
      []

      iex> Flamel.Result.ok!({:error, "message"})
      ** (ArgumentError) {:error, "message"} is not an :ok tuple
  """
  def ok!({:ok, value}) do
    value
  end

  def ok!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :ok tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.Result.error!({:ok, []})
      ** (ArgumentError) {:ok, []} is not an :error tuple

      iex> Flamel.Result.error!({:error, "message"})
      "message"
  """
  def error!({:error, value}) do
    value
  end

  def error!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :error tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value or nil

  ## Examples

      iex> Flamel.Result.ok_or_nil({:ok, []})
      []

      iex> Flamel.Result.ok_or_nil({:error, "message"})
      nil
  """
  def ok_or_nil({:ok, value}) do
    value
  end

  def ok_or_nil(_) do
    nil
  end

  @doc """
  Takes an {:error, value} tuple and returns the value or nil

  ## Examples

      iex> Flamel.Result.error_or_nil({:ok, []})
      nil

      iex> Flamel.Result.error_or_nil({:error, "message"})
      "message"
  """
  def error_or_nil({:error, value}) do
    value
  end

  def error_or_nil(_) do
    nil
  end
end
