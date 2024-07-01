defmodule Flamel.Chain do
  @moduledoc """
  Represents a chain of functions that can be executed in a pipeline.
  """
  alias __MODULE__
  alias Flamel.Context

  @typedoc """
  Flamel.Chain
  """
  @type t :: %__MODULE__{
          halt?: boolean(),
          assigns: map(),
          reason: binary()
        }

  defstruct halt?: false, assigns: %{}, reason: nil

  @doc """
  Create a new chain with a value. The value is the value that the chain's functions are applied to.
  """
  @spec new(any()) :: Chain.t()
  def new(value) do
    Context.assign(%Chain{}, :value, value)
  end

  @doc """
  Creates a function that can be used with `Enum.map/1` to build a chain for each
  item in the enumerable.
  """
  @spec curry((any() -> any())) :: (any() -> any())
  def curry(func) do
    fn value ->
      value
      |> new()
      |> func.()
    end
  end

  @doc """
  Applies a function to the value of the chain. If the function returns a `{:ok, value}` the chain's value is updated. If the function returns a `{:error, reason, value}` then the chain is halted and not further functions will be applied. The chain's reason will be set to the reason provided in the error tuple.
  """
  def apply(%Chain{halt?: true} = context, _func) do
    context
  end

  def apply(%Chain{halt?: false} = context, func) do
    %{value: value} = context.assigns

    case func.(value) do
      {:ok, value} ->
        Context.assign(context, :value, value)

      {:error, error, value} ->
        context
        |> Context.assign(:value, value)
        |> Context.halt!(Flamel.to_string(error))

      value ->
        Context.assign(context, :value, value)
    end
  end

  def value(%Chain{assigns: %{value: value}} = _chain), do: value

  def value(_), do: nil

  def tuple(%Chain{halt?: false, assigns: %{value: value}} = _chain), do: {:ok, value}
  def tuple(%Chain{halt?: true, assigns: %{value: value}, reason: reason} = _chain), do: {:error, reason, value}

  defimpl Flamel.Contextable, for: Flamel.Chain do
    use Flamel.Contextable.Base
  end
end
