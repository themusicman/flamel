defmodule Flamel.Struct do
  @moduledoc """
  A bunch of helper functions for Structs
  """

  @doc """
  Return a list of fields from a strcut

  ## Examples

      iex> Flamel.Struct.fields(%User{a: 1, b: 2})
      [:a, :b]

  """
  def fields(struct) when is_struct(struct) do
    struct |> Map.keys() |> List.delete(:__struct__)
  end

  def fields(_struct) do
    []
  end
end
