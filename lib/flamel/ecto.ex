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

  @doc """
  Takes an Ecto association value and returns nil if %Ecto.Association.NotLoaded{} 
  or the value 

  ## Examples

      iex> Flamel.Ecto.loaded_or_nil([])
      []

      iex> Flamel.Ecto.loaded_or_nil(%Ecto.Association.NotLoaded{})
      nil
  """
  def loaded_or_nil(%Ecto.Association.NotLoaded{}) do
    nil
  end

  def loaded_or_nil(value) do
    value
  end

  @doc """
  Takes an Ecto association value and returns a default value if %Ecto.Association.NotLoaded{} 
  or the value 

  ## Examples

      iex> Flamel.Ecto.loaded_or([])
      []

      iex> Flamel.Ecto.loaded_or(%Ecto.Association.NotLoaded{}, 1)
      1
  """

  def loaded_or(value, default \\ nil)

  def loaded_or(%Ecto.Association.NotLoaded{}, default) do
    default
  end

  def loaded_or(value, _default) do
    value
  end

end
