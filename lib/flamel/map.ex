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

      iex> Flamel.Map.stringify_keys(%{a: 1, b: [%{a: 1}, %{b: 2}]})
      %{"a" => 1, "b" => [%{"a" => 1}, %{"b" => 2}]}

      iex> Flamel.Map.stringify_keys(%{a: 1, b: 2, c: %{d: 3, e: 4}})
      %{"a" => 1, "b" => 2, "c" => %{"d" => 3, "e" => 4}}

      iex> Flamel.Map.stringify_keys(%{"a" => 1, "b" => 2})
      %{"a" => 1, "b" => 2}


  """
  def stringify_keys(value) when is_struct(value), do: value

  def stringify_keys(value) when is_map(value) do
    Map.new(value, fn
      {k, v} when is_map(v) -> {Flamel.to_string(k), stringify_keys(v)}
      {k, v} when is_list(v) -> {Flamel.to_string(k), Enum.map(v, &stringify_keys(&1))}
      {k, v} -> {Flamel.to_string(k), v}
    end)
  end

  @doc """
  Converts the top level keys in a map from string to atoms

  ## Examples

      iex> Flamel.Map.atomize_keys(%{"first_name" => "Thomas", "dob" => "07/01/1981"})
      %{first_name: "Thomas", dob: "07/01/1981"}

      iex> Flamel.Map.atomize_keys(%{"first_name" => "Thomas", "dob" => "07/01/1981", "skills" => [%{"name" => "sewing"}]})
      %{first_name: "Thomas", dob: "07/01/1981", skills: [%{name: "sewing"}]}

      iex> Flamel.Map.atomize_keys(%{"person" => %{"first_name" => "Thomas", "dob" => "07/01/1981"}})
      %{person: %{first_name: "Thomas", dob: "07/01/1981"}}

      iex> Flamel.Map.atomize_keys(%{first_name: "Thomas", dob: "07/01/1981"})
      %{first_name: "Thomas", dob: "07/01/1981"}


  """
  def atomize_keys(value) when is_struct(value), do: value

  def atomize_keys(value) when is_map(value) do
    Map.new(value, fn
      {k, v} when is_map(v) -> {Flamel.to_atom(k), atomize_keys(v)}
      {k, v} when is_list(v) -> {Flamel.to_atom(k), Enum.map(v, &atomize_keys(&1))}
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
    map
    |> Map.get(key, %{})
    |> then(fn assigns ->
      assign(assigns, values)
    end)
    |> then(fn assigns ->
      Map.put(map, key, assigns)
    end)
  end

  @spec assign(map(), atom(), map()) :: map()
  def assign(map, key, values) when is_map(values) do
    map
    |> Map.get(key, %{})
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
      acc
      |> Map.get(key, [])
      |> handle_pushes(value)
      |> then(fn value ->
        Map.put(acc, key, value)
      end)
    end)
  end

  defp handle_pushes(existing, value) when is_list(existing) do
    if is_list(value) do
      Enum.concat(value, existing)
    else
      [value | existing]
    end
  end

  defp handle_pushes(existing, _value), do: existing

  @doc """
  Puts a value in a map if the value for that key is blank
  """
  @spec put_if_blank(map(), binary() | atom(), function()) :: map()
  def put_if_blank(values, key, fun) do
    values
    |> Flamel.Map.Indifferent.get(key, nil)
    |> then(fn value ->
      if Flamel.blank?(value), do: fun.(), else: value
    end)
    |> then(fn value ->
      Map.put(values, key, value)
    end)
  end

  @doc """
  Puts a value in a map if the value is present else it returns the map mutated
  """
  @spec put_if_present(map(), binary() | atom(), any()) :: map()
  def put_if_present(values, key, value) do
    if Flamel.present?(value) do
      Map.put(values, key, value)
    else
      values
    end
  end

  @doc """
  Recursively converts a struct to a map
  """
  @spec from_struct(struct()) :: map()
  def from_struct(value) do
    value
    |> Map.from_struct()
    |> Map.new(fn
      {k, v} when is_struct(v) -> {k, from_struct(v)}
      {k, v} -> {k, v}
    end)
  end
end
