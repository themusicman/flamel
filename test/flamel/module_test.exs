defmodule MyApp.Worker do
  @moduledoc false
  @callback init(state :: term) :: {:ok, new_state :: term} | {:error, reason :: term}
  @callback perform(args :: term, state :: term) ::
              {:ok, result :: term, new_state :: term}
              | {:error, reason :: term, new_state :: term}
end

defmodule MyApp.Sender do
  @moduledoc false
  @behaviour MyApp.Worker

  def init(opts), do: {:ok, opts}

  def perform(_args, _opts), do: :ok
end

defmodule MyApp.Receiver do
  @moduledoc false
  def init(opts), do: {:ok, opts}
end

defmodule Flamel.ModuleTest do
  use ExUnit.Case

  doctest Flamel.Module

  describe "implements?/2" do
    test "returns true if the module implements the behaviour" do
      assert Flamel.Module.implements?(MyApp.Sender, MyApp.Worker)
    end

    test "returns false if the module does not implement the behaviour" do
      refute Flamel.Module.implements?(MyApp.Receiver, MyApp.Worker)
    end
  end
end
