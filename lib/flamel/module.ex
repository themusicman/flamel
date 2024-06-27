defmodule Flamel.Module do
  @moduledoc """
  A set of helper functions for modules
  """

  @doc """
  Returns `true` if a module implements behaviour.
  """
  @spec implements?(module(), atom()) :: boolean()
  def implements?(module, behaviour) do
    behaviours = Keyword.take(module.__info__(:attributes), [:behaviour])
    [behaviour] in Keyword.values(behaviours)
  end
end
