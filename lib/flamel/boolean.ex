defprotocol Flamel.Boolean do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Boolean` protocol is responsible for
  converting a structure to an Boolean (only if applicable).

  """

  @doc """
  Converts `term` to a Boolean.
  """
  @spec to(t) :: boolean()
  def to(value)
end

defimpl Flamel.Boolean, for: Any do
  def to(_) do
    false
  end
end

defimpl Flamel.Boolean, for: Atom do
  def to(nil) do
    false
  end

  def to(true) do
    true
  end

  def to(false) do
    false
  end
end

defimpl Flamel.Boolean, for: Integer do
  def to(1) do
    true
  end

  def to(0) do
    false
  end
end

defimpl Flamel.Boolean, for: BitString do
  def to("Y" = value) when is_binary(value), do: true
  def to("y" = value) when is_binary(value), do: true
  def to("YES" = value) when is_binary(value), do: true
  def to("Yes" = value) when is_binary(value), do: true
  def to("yes" = value) when is_binary(value), do: true
  def to("true" = value) when is_binary(value), do: true
  def to("TRUE" = value) when is_binary(value), do: true
  def to("1" = value) when is_binary(value), do: true
  def to("N" = value) when is_binary(value), do: false
  def to("n" = value) when is_binary(value), do: false
  def to("NO" = value) when is_binary(value), do: false
  def to("No" = value) when is_binary(value), do: false
  def to("no" = value) when is_binary(value), do: false
  def to("false" = value) when is_binary(value), do: false
  def to("0" = value) when is_binary(value), do: false

  def to(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a atom"
  end
end
