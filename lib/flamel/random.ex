defmodule Flamel.Random do
  @moduledoc """
  Helper functions for generating random values
  """

  @doc """
    Generates a random string of the specified length using cryptographic strong random bytes.
  """
  @spec string(pos_integer) :: binary
  def string(length \\ 10) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> binary_part(0, length)
  end
end
