defmodule Flamel.Map.Indifferent do
  @moduledoc """
  A set of helper functions for accessing a map with indifferent access.
  These functions are inspired by the behavior of Ruby/Rails, where keys in a hash can be accessed with indifferent access.
  """

  @doc """
  Get a value from a map whether the key is a string or atom

  ## Examples

      iex> Flamel.Map.Indifferent.get(%{test: "value"}, "test")
      "value"

      iex> Flamel.Map.Indifferent.get(%{test: "value"}, :test)
      "value"

      iex> Flamel.Map.Indifferent.get(%{"test" => "value"}, :test)
      "value"

      iex> Flamel.Map.Indifferent.get(%{"test" => "value"}, "test")
      "value"

      iex> Flamel.Map.Indifferent.get(%{"test" => "value"}, "does-not-exist", "default")
      "default"
  """
  def get(map, key, default \\ nil)

  def get(map, key, default) when is_atom(key) do
    Map.get(map, key, Map.get(map, Flamel.to_string(key), default))
  end

  def get(map, key, default) when is_binary(key) do
    Map.get(map, key, Map.get(map, Flamel.to_atom(key), default))
  end
end
