defprotocol Flamel.Blank do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Blank` protocol is responsible for
  determining if something is blank

  """

  @doc """
  Converts `term` to a Boolean
  """
  @spec blank?(t) :: boolean()
  def blank?(value)
end

# For example, false, ”, ‘ ’, nil, [], and {}

defimpl Flamel.Blank, for: Any do
  def blank?(_), do: false
end

defimpl Flamel.Blank, for: Atom do
  def blank?(nil), do: true
  def blank?(_), do: false
end

defimpl Flamel.Blank, for: List do
  def blank?([]), do: true
  def blank?(_), do: false
end

defimpl Flamel.Blank, for: Map do
  def blank?(value) when value == %{}, do: true
  def blank?(_), do: false
end

defimpl Flamel.Blank, for: BitString do
  def blank?(value) when is_binary(value), do: String.trim(value) == ""

  def blank?(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a atom"
  end
end
