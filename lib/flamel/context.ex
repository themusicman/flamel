defmodule Flamel.Context do
  @moduledoc """
  A Context can be used to in a pipeline to assign data to that future functions 
  can have access to and transform. It also includes a boolean value that 
  signals to other functions in the pipeline whether they should process the 
  context or not.

  ## Example

  ```
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

  def perform_action(%Context{halt?: true}) do
    # do nothing
    context
  end

  def perform_action(%Context{assigns: %{user: user}} = context) do
    # Do something
    Context.assign(context, %{action_performed_by: user, action_performed?: true})
  end
  ```

  """

  alias __MODULE__

  @typedoc """
  Flamel.Context
  """
  @type t :: %__MODULE__{
          halt?: boolean(),
          assigns: map(),
          reason: binary()
        }

  defstruct halt?: false, assigns: %{}, reason: nil

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
  @spec assign(term(), binary() | atom(), term()) :: term
  def assign(context, key, value) when is_atom(key) do
    Flamel.Contextable.assign(context, key, value)
  end

  @doc """
  If given a map it will merge values into the assigns in the context. It does not
  perform a deep merge.

  If given a keyword list it will set values in the assigns. You can also push a value into the key if the value is a list.

  ## Examples

      iex> context = Flamel.Context.assign(%Flamel.Context{}, %{hello: :world})
      iex> context.assigns[:hello]
      :world


      iex> context = Flamel.Context.assign(%Flamel.Context{assigns: %{tags: []}}, set: [hello: :world], push: [tags: "new"])
      iex> context.assigns[:hello]
      :world
      iex> context.assigns[:tags]
      ["new"]

  """
  @spec assign(term(), map()) :: term()
  def assign(context, map) when is_map(map) do
    Flamel.Contextable.assign(context, map)
  end

  @spec assign(term(), keyword()) :: term()
  def assign(context, args) when is_list(args) do
    Flamel.Contextable.assign(context, args)
  end

  @doc """
  Signals to further functions in the pipeline that processing should stop

  ## Examples

      iex> context = %Flamel.Context{}
      iex> context.halt?
      false
      iex> context = Flamel.Context.halt!(context, "no more")
      iex> context.halt?
      true

      iex> context = %Flamel.Context{}
      iex> context.halt?
      false
      iex> context = Flamel.Context.halt!(context, "some error message")
      iex> context.halt?
      true
      iex> context.reason
      "some error message"



  """
  @spec halt!(term(), binary()) :: term()
  def halt!(context, reason) do
    Flamel.Contextable.halt!(context, reason)
  end

  @doc """
  Has the context been halted?

  ## Examples

      iex> context = Flamel.Context.halt!(%Flamel.Context{}, "stop it")
      iex> Flamel.Context.halted?(context)
      true

  """
  @spec halted?(term()) :: boolean()
  def halted?(context), do: Flamel.Contextable.halted?(context)

  @doc """
  Signals to further functions in the pipeline that processing should resume

  ## Examples

      iex> context = %Flamel.Context{halt?: true}
      iex> context.halt?
      true
      iex> context = Flamel.Context.resume!(context)
      iex> context.halt?
      false


  """
  @spec resume!(term()) :: term()
  def resume!(context) do
    Flamel.Contextable.resume!(context)
  end
end

defimpl Flamel.Contextable, for: Flamel.Context do
  alias Flamel.Context
  alias Flamel.Map

  def assign(%Context{} = context, key, value) when is_atom(key) do
    Map.assign(context, :assigns, set: [{key, value}])
  end

  def assign(%Context{} = context, map) when is_map(map) do
    Map.assign(context, :assigns, map)
  end

  def assign(%Context{} = context, args) when is_list(args) do
    Map.assign(context, :assigns, args)
  end

  def halt!(%Context{} = context, reason) do
    Map.assign(context, set: [halt?: true, reason: reason])
  end

  def halted?(%Context{halt?: true}), do: true
  def halted?(_), do: false

  def resume!(%Context{} = context) do
    Map.assign(context, set: [halt?: false, reason: nil])
  end
end
