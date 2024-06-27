defprotocol Flamel.Contextable do
  @moduledoc """
  The `Flamel.Contextable` protocol for working with something that
  stores a generic data structure and has the ability to.
  """
  @fallback_to_any true

  @doc """
  Assigns a value to a key in the context.
  """
  @spec assign(term(), binary() | atom(), term()) :: term()
  def assign(context, key, value)

  @doc """
  Merges values in a map into the assigns in the context.
  """
  @spec assign(term(), map() | keyword()) :: term()
  def assign(context, map)

  @doc """
  Signals to further functions in the pipeline that processing should stop
  """
  @spec halt!(term(), binary()) :: term()
  def halt!(context, reason)

  @doc """
  Has the context been halted?
  """

  @spec halted?(term()) :: boolean()
  def halted?(context)

  @doc """
  Signals to further functions in the pipeline that processing should resume

  """
  @spec resume!(term()) :: term()
  def resume!(context)
end
