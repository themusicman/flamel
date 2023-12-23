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
          assigns: map()
        }

  defstruct halt: false, assigns: %{}

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
  def assign(%Context{} = context, key, value) do
    assigns = context.assigns
    assigns = Map.put(assigns, key, value)
    %{context | assigns: assigns}
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


  """
  def halt!(%Context{} = context) do
    %{context | halt: true}
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
