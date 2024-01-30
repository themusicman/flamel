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
  def unwrap({:reply, value}), do: value
  def unwrap({:noreply, value}), do: value
  def unwrap({:continue, value}), do: value
  def unwrap({:cont, value}), do: value

  @doc """
  Takes a value and wraps it in a tuple with the specified 
  atom as the first item

  ## Examples

      iex> Flamel.Wrap.wrap(:ok, [])
      {:ok, []}

      iex> Flamel.Wrap.wrap(:error, "message")
      {:error, "message"}

      iex> Flamel.Wrap.wrap(:stop, :shutdown, %{})
      {:stop, :shutdown, %{}}
  """
  @spec wrap(atom(), term()) :: {atom(), term()}
  def wrap(item, value), do: {item, value}

  @spec wrap(atom(), term(), term()) :: {atom(), term(), term()}
  def wrap(item, first, second), do: {item, first, second}

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

  @spec ok(term(), term()) :: {:ok, term(), term()}
  def ok(first, second), do: Flamel.Wrap.wrap(:ok, first, second)

  @doc """
  Takes a value and wraps it in a :error tuple

  ## Examples

      iex> Flamel.Wrap.error([])
      {:error, []}

      iex> Flamel.Wrap.error("message")
      {:error, "message"}

      iex> Flamel.Wrap.error(:first, :second)
      {:error, :first, :second}
  """
  @spec error(term()) :: {:error, term()}
  def error(value), do: Flamel.Wrap.wrap(:error, value)

  @spec error(term(), term()) :: {:error, term(), term()}
  def error(first, second), do: Flamel.Wrap.wrap(:error, first, second)

  @doc """
  Takes a value and wraps it in a :noreply tuple

  ## Examples

      iex> Flamel.Wrap.noreply([])
      {:noreply, []}

      iex> Flamel.Wrap.noreply("message")
      {:noreply, "message"}

      iex> Flamel.Wrap.noreply(:first, :second)
      {:noreply, :first, :second}
  """
  @spec noreply(term()) :: {:noreply, term()}
  def noreply(value), do: Flamel.Wrap.wrap(:noreply, value)

  @spec noreply(term(), term()) :: {:noreply, term(), term()}
  def noreply(first, second), do: Flamel.Wrap.wrap(:noreply, first, second)

  @doc """
  Takes a value and wraps it in a :reply tuple

  ## Examples

      iex> Flamel.Wrap.reply([])
      {:reply, []}

      iex> Flamel.Wrap.reply("message")
      {:reply, "message"}

      iex> Flamel.Wrap.reply(:first, :second)
      {:reply, :first, :second}
  """
  @spec reply(term()) :: {:reply, term()}
  def reply(value), do: Flamel.Wrap.wrap(:reply, value)

  @spec reply(term(), term()) :: {:reply, term(), term()}
  def reply(first, second), do: Flamel.Wrap.wrap(:reply, first, second)

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

      iex> Flamel.Wrap.continue(:first, :second)
      {:continue, :first, :second}
  """
  @spec continue(term()) :: {:continue, term()}
  def continue(value), do: Flamel.Wrap.wrap(:continue, value)

  @spec continue(term(), term()) :: {:continue, term(), term()}
  def continue(first, second), do: Flamel.Wrap.wrap(:continue, first, second)
end
