defmodule Flamel.Map.Safely do
  @moduledoc """
  Helpers for working with maps safely. Don't use this all the time but
  sometimes you want to be as safe as possible.
  """
  require Logger

  @doc """
  Safely get a value out of Map/Struct
  """
  @spec get(map() | struct(), function() | atom()) :: any()
  def get(var, func_or_atom) do
    get(var, func_or_atom, "")
  end

  @spec get(map() | struct(), function() | atom(), any()) :: any()
  def get(var, func, default) when is_function(default) do
    get(var, func, default.(var))
  rescue
    e in KeyError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      nil

    e in RuntimeError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      nil
  end

  def get(var, field, default) when is_atom(field) do
    if var do
      Map.get(var, field, default)
    else
      default
    end
  rescue
    e in BadMapError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      default

    e in RuntimeError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      default
  end

  def get(var, func, default) when is_function(func) do
    if var do
      func.(var)
    else
      default
    end
  rescue
    e in KeyError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      default

    e in RuntimeError ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      default
  end
end
