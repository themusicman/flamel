defmodule Flamel.TaskTest do
  use ExUnit.Case

  setup do
    children = [
      {Task.Supervisor, name: Flamel.Task}
    ]

    opts = [strategy: :one_for_one, name: Flamel.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    {:ok, pid: pid}
  end

  describe "async/2" do
    test "when given a single function and executes it  awaiting the result" do
      assert Flamel.Task.async(fn -> "test" end) == "test"
    end
  end

  describe "stream/3" do
    test "when given a stream of items asynchronously process them and return the results" do
      assert Flamel.Task.stream([1, 2, 3], fn n -> n + 1 end) == [{:ok, 2}, {:ok, 3}, {:ok, 4}]
    end
  end
end
