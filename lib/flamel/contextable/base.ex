defmodule Flamel.Contextable.Base do
  @moduledoc """
  Base module that includes functions for working with `Flamel.Context`
  """
  defmacro __using__(_opts) do
    quote do
      def assign(context, key, value) when is_atom(key) do
        Flamel.Map.assign(context, :assigns, set: [{key, value}])
      end

      def assign(context, map) when is_map(map) do
        Flamel.Map.assign(context, :assigns, map)
      end

      def assign(context, args) when is_list(args) do
        Flamel.Map.assign(context, :assigns, args)
      end

      def halt!(context, reason) do
        Flamel.Map.assign(context, set: [halt?: true, reason: reason])
      end

      def halted?(%{halt?: true}), do: true
      def halted?(_), do: false

      def resume!(context) do
        Flamel.Map.assign(context, set: [halt?: false, reason: nil])
      end
    end
  end
end
