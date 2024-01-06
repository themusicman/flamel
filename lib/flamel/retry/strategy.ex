defprotocol Flamel.Retry.Strategy do
  @moduledoc """
  The `Flamel.Retry.Strategy` protocol calculates the backoff interval 
  to be used in situation that requires an action to be performed
  again and at a different time because of a problem that occurred 
  previously while performing that action.
  """
  @fallback_to_any true

  @doc """
  Calculate the next retry interval. It might also signal to stop retrying
  """
  @spec calc(term()) :: {:retry, Flamel.Retry.interval(), term()} | {:stop, term()}
  def calc(t)
end
