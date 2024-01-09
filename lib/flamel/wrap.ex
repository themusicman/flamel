defmodule Flamel.Wrap do
  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.Wrap.unwrap_ok!({:ok, []})
      []

      iex> Flamel.Wrap.unwrap_ok!({:error, "message"})
      ** (ArgumentError) {:error, "message"} is not an :ok tuple
  """
  def unwrap_ok!({:ok, value}) do
    value
  end

  def unwrap_ok!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :ok tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value

  ## Examples

      iex> Flamel.Wrap.unwrap_error!({:ok, []})
      ** (ArgumentError) {:ok, []} is not an :error tuple

      iex> Flamel.Wrap.unwrap_error!({:error, "message"})
      "message"
  """
  def unwrap_error!({:error, value}) do
    value
  end

  def unwrap_error!(value) do
    raise ArgumentError, message: "#{inspect(value)} is not an :error tuple"
  end

  @doc """
  Takes an {:ok, value} tuple and returns the value or nil

  ## Examples

      iex> Flamel.Wrap.unwrap_ok_or_nil({:ok, []})
      []

      iex> Flamel.Wrap.unwrap_ok_or_nil({:error, "message"})
      nil
  """
  def unwrap_ok_or_nil({:ok, value}) do
    value
  end

  def unwrap_ok_or_nil(_) do
    nil
  end

  @doc """
  Takes an {:error, value} tuple and returns the value or nil 

  ## Examples

      iex> Flamel.Wrap.unwrap_error_or_nil({:ok, []})
      nil

      iex> Flamel.Wrap.unwrap_error_or_nil({:error, "message"})
      "message"
  """
  def unwrap_error_or_nil({:error, value}) do
    value
  end

  def unwrap_error_or_nil(_) do
    nil
  end

  @doc """
  Takes an {:ok, value} or {:error, message} tuple and returns the value

  ## Examples

      iex> Flamel.Wrap.unwrap({:ok, []})
      []

      iex> Flamel.Wrap.unwrap({:error, "message"})
      "message"
  """
  def unwrap({:ok, value}), do: value
  def unwrap({:error, value}), do: value

  @doc """
  Takes a value and wraps it in a tuple with the specified 
  atom as the first item

  ## Examples

      iex> Flamel.Wrap.wrap(:ok, [])
      {:ok, []}

      iex> Flamel.Wrap.wrap(:error, "message")
      {:error, "message"}
  """
  @spec wrap(atom(), term()) :: {atom(), term()}
  def wrap(item, value), do: {item, value}

  @doc """
  Takes a value and wraps it in a :ok tuple

  ## Examples

      iex> Flamel.Wrap.ok([])
      {:ok, []}

      iex> Flamel.Wrap.ok("message")
      {:ok, "message"}
  """
  @spec ok(term()) :: {:ok, term()}
  def ok(value), do: Flamel.Wrap.wrap(:ok, value)

  @doc """
  Takes a value and wraps it in a :error tuple

  ## Examples

      iex> Flamel.Wrap.error([])
      {:error, []}

      iex> Flamel.Wrap.error("message")
      {:error, "message"}
  """
  @spec error(term()) :: {:error, term()}
  def error(value), do: Flamel.Wrap.wrap(:error, value)

  @doc """
  Takes a value and wraps it in a :noreply tuple

  ## Examples

      iex> Flamel.Wrap.noreply([])
      {:noreply, []}

      iex> Flamel.Wrap.noreply("message")
      {:noreply, "message"}
  """
  @spec noreply(term()) :: {:noreply, term()}
  def noreply(value), do: Flamel.Wrap.wrap(:noreply, value)

  @doc """
  Takes a value and wraps it in a :cont tuple

  ## Examples

      iex> Flamel.Wrap.cont([])
      {:cont, []}

      iex> Flamel.Wrap.cont("message")
      {:cont, "message"}
  """
  @spec cont(term()) :: {:cont, term()}
  def cont(value), do: Flamel.Wrap.wrap(:cont, value)

  @doc """
  Takes a value and wraps it in a :continue tuple

  ## Examples

      iex> Flamel.Wrap.continue(:load_something)
      {:continue, :load_something}

      iex> Flamel.Wrap.continue("message")
      {:continue, "message"}
  """
  @spec continue(term()) :: {:continue, term()}
  def continue(value), do: Flamel.Wrap.wrap(:continue, value)
end
