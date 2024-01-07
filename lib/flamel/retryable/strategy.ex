defprotocol Flamel.Retryable.Strategy do
  @moduledoc """
  The `Flamel.Retryable.Strategy` protocol calculates the retry interval 
  to be used in situation that requires an action to be performed
  again and at a different time because of a problem that occurred 
  previously while performing that action.
  """
  @fallback_to_any true

  @doc """
  Calculate the next retry interval. It might also signal to stop retrying
  """
  @spec calc(term()) :: {:retry, Flamel.Retryable.interval(), term()} | {:stop, term()}
  def calc(t)
end
