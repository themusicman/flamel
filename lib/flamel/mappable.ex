defprotocol Flamel.Mappable do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Mappable` protocol is responsible for
  converting a structure to an Map (only if applicable).

  """

  @doc """
  Converts `term` to a Map.
  """
  @spec to(t) :: map()
  def to(value)
end

defimpl Flamel.Mappable, for: Any do
  def to(value) when is_struct(value) do
    Map.from_struct(value)
  end

  def to(_) do
    %{}
  end
end

defimpl Flamel.Mappable, for: Map do
  def to(value) when is_map(value) do
    value
  end
end
