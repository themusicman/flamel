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
  Assign values in a map 

  ## Examples

      iex> map = Flamel.Map.assign(%{tags: []}, push: [tags: "new"])
      iex> map[:tags] 
      iex> ["new"]

      iex> map = Flamel.Map.assign(%{}, set: [name: "Clark"])
      iex> map[:name] 
      iex> "Clark"

      iex> map = Flamel.Map.assign(%{assigns: %{}}, :assigns, set: [name: "Osa"])
      iex> get_in(map, [:assigns, :name])
      iex> "Osa"

      iex> map = Flamel.Map.assign(%{assigns: %{}}, :assigns, %{name: "Clark"})
      iex> get_in(map, [:assigns, :name])
      iex> "Clark"
  """

  @spec assign(map(), atom(), keyword()) :: map()
  def assign(map, key, values) when is_list(values) do
    Map.get(map, key, %{})
    |> then(fn assigns ->
      assign(assigns, values)
    end)
    |> then(fn assigns ->
      Map.put(map, key, assigns)
    end)
  end

  @spec assign(map(), atom(), map()) :: map()
  def assign(map, key, values) when is_map(values) do
    Map.get(map, key, %{})
    |> Map.merge(values)
    |> then(fn assigns ->
      Map.put(map, key, assigns)
    end)
  end

  @spec assign(map(), keyword()) :: map()
  def assign(assigns, values) when is_list(values) do
    set = Keyword.get(values, :set, [])
    push = Keyword.get(values, :push, [])

    assigns =
      Enum.reduce(set, assigns, fn {key, value}, acc ->
        Map.put(acc, key, value)
      end)

    Enum.reduce(push, assigns, fn {key, value}, acc ->
      Map.get(acc, key, [])
      |> then(fn
        list when is_list(list) ->
          if is_list(value) do
            Enum.concat(value, list)
          else
            [value | list]
          end

        list ->
          list
      end)
      |> then(fn value ->
        Map.put(acc, key, value)
      end)
    end)
  end
end
