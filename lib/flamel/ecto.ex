defmodule Flamel.Ecto do
  @moduledoc """
  A collection of helpers functions for Ecto
  """

  @doc """
  Test to see if an association is loaded or not

  *The examples below use maps to mock Ecto schema structs*

  ## Examples


      iex> user = %{profile: %{first_name: "Jill"}}
      iex> Flamel.Ecto.loaded?(user.profile)
      true


      iex> user = %{profile: %Ecto.Association.NotLoaded{}}
      iex> Flamel.Ecto.loaded?(user.profile)
      false

  """
  @spec loaded?(struct()) :: boolean()
  def loaded?(%Ecto.Association.NotLoaded{}), do: false
  def loaded?(_), do: true
end
