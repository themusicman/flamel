defmodule Flamel.Context do
  @moduledoc """
  A Context can be used to in a pipeline to assign data to that future functions 
  can have access to and transform. It also includes a boolean value that 
  signals to other functions in the pipeline whether they should process the 
  context or not.

  ## Example

    alias Flamel.Context

    context =
      Context.new()
      |> assign_user(user)
      |> authorize()
      |> perform_action()

    if context.assigns[:action_performed?] do
      # something you are allowed to do
    end

    def assign_user?(%Context{} = context, user) do
      Context.assign(context, :user, user)
    end

    def authorize(%Context{assigns: %{user: %{type: :admin}} = context) do
      context
    end

    def authorize(%Context{} = context) do
      Context.halt!(context, "Not permitted")
    end

    def perform_action(%Context{halt: true}) do
      # do nothing
      context
    end

    def perform_action(%Context{assigns: %{user: user}} = context) do
      # Do something
      Context.assign(context, %{action_performed_by: user, action_performed?: true})
    end

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
  Build a new Context
  """
  @spec new(map()) :: %Context{}
  def new(assigns \\ %{})

  def new(assigns) when is_map(assigns) do
    %Context{assigns: assigns}
  end

  def new(_) do
    raise ArgumentError, "Must pass a map to Flamel.Context.new/1"
  end

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
  Merges a values in a map into the assigns in the context. It does not
  perform a deep merge.

  ## Examples

      iex> context = Flamel.Context.assign(Flamel.Context.new(), %{hello: :world})
      iex> context.assigns[:hello]
      :world


  """
  @spec assign(%Context{}, map()) :: %Context{}
  def assign(%Context{} = context, map) when is_map(map) do
    %{context | assigns: Map.merge(context.assigns, map)}
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
  Has the context been halted?

  ## Examples

      iex> context = Flamel.Context.halt!(%Flamel.Context{})
      iex> Flamel.Context.halted?(context)
      true

  """
  def halted?(%Context{halt: true}), do: true
  def halted?(_), do: false

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
