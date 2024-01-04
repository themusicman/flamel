defprotocol Flamel.Integer do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Integer` protocol is responsible for
  converting a structure to an Integer (only if applicable).

  """

  @doc """
  Converts `term` to a Integer.
  """
  @spec to(t) :: integer()
  def to(value)
end

defimpl Flamel.Integer, for: Any do
  def to(_) do
    0
  end
end

defimpl Flamel.Integer, for: Atom do
  def to(nil) do
    0
  end

  def to(value) do
    value |> Flamel.String.to() |> Flamel.Integer.to()
  end
end

defimpl Flamel.Integer, for: Integer do
  def to(value) do
    value
  end
end

defimpl Flamel.Integer, for: Float do
  def to(value) do
    value |> trunc()
  end
end

defimpl Flamel.Integer, for: BitString do
  def to(value) when is_binary(value) do
    String.to_integer(value)
  end

  def to(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a atom"
  end
end
