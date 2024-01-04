defprotocol Flamel.Float do
  @fallback_to_any true
  @moduledoc ~S"""
  The `Flamel.Float` protocol is responsible for
  converting a structure to an Float (only if applicable).

  """

  @doc """
  Converts `term` to a Float.
  """
  @spec to(t) :: float()
  def to(value)
end

defimpl Flamel.Float, for: Any do
  def to(_) do
    0.0
  end
end

defimpl Flamel.Float, for: Atom do
  def to(nil) do
    0.0
  end

  def to(value) do
    value |> Flamel.String.to() |> Flamel.Float.to()
  end
end

defimpl Flamel.Float, for: Integer do
  def to(value) do
    value
    |> Flamel.String.to()
    |> Flamel.Float.to()
  end
end

defimpl Flamel.Float, for: Float do
  def to(value) do
    value
  end
end

defimpl Flamel.Float, for: BitString do
  def to(value) when is_binary(value) do
    value
    |> Float.parse()
    |> case do
      {value, _} ->
        value

      _ ->
        0.0
    end
  end

  def to(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "cannot convert a bitstring to a atom"
  end
end
