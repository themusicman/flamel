defmodule Backoff.RetryExhaustedError do
  defexception message: "Retries exhausted"
end
