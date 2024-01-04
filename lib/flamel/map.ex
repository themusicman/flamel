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
end
