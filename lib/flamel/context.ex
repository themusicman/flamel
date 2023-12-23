defmodule Flamel.Context do
  @moduledoc """
  A Context can be used to in a pipeline to assign data to that future functions 
  can have access to and transform. It also includes a boolean value that 
  signals to other functions in the pipeline whether they should process the 
  context or not.
  """

  alias __MODULE__

  @typedoc """
  Flamel.Context
  """
  @type t :: %__MODULE__{
          halt: boolean(),
          assigns: map(),
          reason: binary()
        }

  defstruct halt: false, assigns: %{}, reason: nil

  @doc """
  Assigns a value to a key in the context.

  The assigns is meant to be used to store values in the context so that other functions in your pipeline can access them. The assigns storage is a map.

  ## Examples

      iex> context = %Flamel.Context{}
      iex> context.assigns[:hello]
      nil
      iex> context = Flamel.Context.assign(context, :hello, :world)
      iex> context.assigns[:hello]
      :world


  """
  @spec assign(%Context{}, binary() | atom(), term()) :: %Context{}
  def assign(%Context{} = context, key, value) when is_atom(key) do
    %{context | assigns: Map.put(context.assigns, key, value)}
  end

  @doc """
  Signals to further functions in the pipeline that processing should stop

  ## Examples

      iex> context = %Flamel.Context{}
      iex> context.halt
      false
      iex> context = Flamel.Context.halt!(context)
      iex> context.halt
      true

      iex> context = %Flamel.Context{}
      iex> context.halt
      false
      iex> context = Flamel.Context.halt!(context, "some error message")
      iex> context.halt
      true
      iex> context.reason
      "some error message"



  """
  def halt!(%Context{} = context, reason \\ nil) do
    %{context | halt: true, reason: reason}
  end

  @doc """
  Signals to further functions in the pipeline that processing should resume

  ## Examples

      iex> context = %Flamel.Context{halt: true}
      iex> context.halt
      true
      iex> context = Flamel.Context.resume!(context)
      iex> context.halt
      false


  """
  def resume!(%Context{} = context) do
    %{context | halt: false}
  end
end
