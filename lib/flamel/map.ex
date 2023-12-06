defmodule Flamel.Map do
  @moduledoc """
  A bunch of helper functions for Maps
  """

  require Logger

  @doc """
  Converts the top level keys in a map from atoms to strings

  ## Examples

      iex> Flamel.Map.stringify_keys(%{a: 1, b: 2})
      %{"a" => 1, "b" => 2}

      iex> Flamel.Map.stringify_keys(%{a: 1, b: 2, c: %{d: 3, e: 4}})
      %{"a" => 1, "b" => 2, "c" => %{"d" => 3, "e" => 4}}

      iex> Flamel.Map.stringify_keys(%{"a" => 1, "b" => 2})
      %{"a" => 1, "b" => 2}


  """
  def stringify_keys(value) when is_struct(value), do: value

  def stringify_keys(value) when is_map(value) do
    value
    |> Map.new(fn
      {k, v} when is_map(v) -> {Flamel.to_string(k), stringify_keys(v)}
      {k, v} -> {Flamel.to_string(k), v}
    end)
  end

  @doc """
  Converts the top level keys in a map from string to atoms

  ## Examples

      iex> Flamel.Map.atomize_keys(%{"first_name" => "Thomas", "dob" => "07/01/1981"})
      %{first_name: "Thomas", dob: "07/01/1981"}

      iex> Flamel.Map.atomize_keys(%{"person" => %{"first_name" => "Thomas", "dob" => "07/01/1981"}})
      %{person: %{first_name: "Thomas", dob: "07/01/1981"}}

      iex> Flamel.Map.atomize_keys(%{first_name: "Thomas", dob: "07/01/1981"})
      %{first_name: "Thomas", dob: "07/01/1981"}


  """
  def atomize_keys(value) when is_struct(value), do: value

  def atomize_keys(value) when is_map(value) do
    value
    |> Map.new(fn
      {k, v} when is_map(v) -> {Flamel.to_atom(k), atomize_keys(v)}
      {k, v} -> {Flamel.to_atom(k), v}
    end)
  end

  @doc """
  Safely get a value out of Map/Struct
  """
  @spec safely_get(map() | struct(), function() | atom()) :: any()
  def safely_get(var, func_or_atom) do
    safely_get(var, func_or_atom, "")
  end

  @spec safely_get(map() | struct(), function() | atom(), any()) :: any()
  def safely_get(var, func, default) when is_function(default) do
    try do
      safely_get(var, func, default.(var))
    rescue
      e in KeyError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        nil

      e in RuntimeError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        nil
    end
  end

  def safely_get(var, field, default) when is_atom(field) do
    try do
      if var do
        Map.get(var, field, default)
      else
        default
      end
    rescue
      e in BadMapError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        default

      e in RuntimeError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        default
    end
  end

  def safely_get(var, func, default) when is_function(func) do
    try do
      if var do
        func.(var)
      else
        default
      end
    rescue
      e in KeyError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        default

      e in RuntimeError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
        default
    end
  end

  @doc """
  Get a value from a map whether the key is a string or atom

  Examples

  iex> Flamel.Map.indifferent_get(%{test: "value"}, "test")
  "value"

  iex> Flamel.Map.indifferent_get(%{test: "value"}, :test)
  "value"

  iex> Flamel.Map.indifferent_get(%{"test" => "value"}, :test)
  "value"

  iex> Flamel.Map.indifferent_get(%{"test" => "value"}, "test")
  "value"

  iex> Flamel.Map.indifferent_get(%{"test" => "value"}, "does-not-exist", "default")
  "default"
  """
  def indifferent_get(map, key, default \\ nil)

  def indifferent_get(map, key, default) when is_atom(key) do
    Map.get(map, key, Map.get(map, to_string(key), default))
  end

  def indifferent_get(map, key, default) when is_binary(key) do
    Map.get(map, key, Map.get(map, String.to_atom(key), default))
  end
end
