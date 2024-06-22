defmodule Flamel.Number do
  @moduledoc """
  Documentation for `Flamel.Number`.
  """

  @doc """
  Returns value clamped to the inclusive range of min and max.

      iex> Flamel.Number.clamp(-10, 0)
      0

      iex> Flamel.Number.clamp(20, 0, 10)
      10

      iex> Flamel.Number.clamp(20, 0)
      20
  """
  @spec clamp(integer(), integer(), integer() | :infinity) :: integer()
  def clamp(value, min, max \\ :infinity)
  def clamp(value, min, _max) when value < min, do: min
  def clamp(value, _min, max) when value > max, do: max
  def clamp(value, _min, _max), do: value
end
