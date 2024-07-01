defmodule Flamel.Result do
  @moduledoc """
  Some helper functions for dealing with result tuples
  """

  import Flamel.Wrap, only: [ok: 1]

  @doc """
  Returns true if the value is an `:ok`, `{:ok, value}`, `{:ok, value, value}`

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

      iex> Flamel.Result.unwrap_ok!({:ok, []})
      []

      iex> Flamel.Result.unwrap_ok!({:error, "message"})
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

      iex> Flamel.Result.unwrap_error!({:ok, []})
      ** (ArgumentError) {:ok, []} is not an :error tuple

      iex> Flamel.Result.unwrap_error!({:error, "message"})
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

      iex> Flamel.Result.unwrap_ok_or_nil({:ok, []})
      []

      iex> Flamel.Result.unwrap_ok_or_nil({:error, "message"})
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

      iex> Flamel.Result.unwrap_error_or_nil({:ok, []})
      nil

      iex> Flamel.Result.unwrap_error_or_nil({:error, "message"})
      "message"
  """
  def unwrap_error_or_nil({:error, value}) do
    value
  end

  def unwrap_error_or_nil(_) do
    nil
  end
end
