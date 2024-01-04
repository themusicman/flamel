defprotocol Flamel.String do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.String` protocol is responsible for
  converting a structure to an String (only if applicable).

  """

  @doc """
  Converts `term` to a String
  """
  @spec to(t) :: binary()
  def to(value)
end

# def to_string(value) when is_nil(value) do
#   ""
# end

defimpl Flamel.String, for: Any do
  def to(_) do
    ""
  end
end

defimpl Flamel.String, for: Atom do
  def to(nil) do
    ""
  end

  def to(value) do
    Atom.to_string(value)
  end
end

defimpl Flamel.String, for: Integer do
  def to(value) do
    Integer.to_string(value)
  end
end

defimpl Flamel.String, for: Float do
  def to(value) do
    Float.to_string(value)
  end
end

defimpl Flamel.String, for: BitString do
  def to(value) when is_binary(value) do
    value
  end

  def to(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a string"
  end
end
