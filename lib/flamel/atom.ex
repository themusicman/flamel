defprotocol Flamel.Atom do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Atom` protocol is responsible for
  converting a structure to an Atom (only if applicable).

  """

  @doc """
  Converts `term` to a Atom.
  """
  @spec to(t) :: atom() | nil
  def to(value)
end

defimpl Flamel.Atom, for: Any do
  def to(_) do
    nil
  end
end

defimpl Flamel.Atom, for: Atom do
  def to(value) do
    value
  end
end

defimpl Flamel.Atom, for: Integer do
  def to(value) do
    value |> Flamel.to_string() |> Flamel.Atom.to()
  end
end

defimpl Flamel.Atom, for: Float do
  def to(value) do
    value |> Flamel.to_string() |> Flamel.Atom.to()
  end
end

defimpl Flamel.Atom, for: BitString do
  # sobelow_skip ["DOS.StringToAtom"]
  def to(value) when is_binary(value) do
    String.to_atom(value)
  end

  def to(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a atom"
  end
end
