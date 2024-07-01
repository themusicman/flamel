# Flamel

[![Elixir CI](https://github.com/themusicman/flamel/actions/workflows/elixir.yml/badge.svg)](https://github.com/themusicman/flamel/actions/workflows/elixir.yml)

This package is a bag of helper functions. Some might be questionable but they are what they are so use them as you will.

## Installation

In your `mix.exs`:

```elixir
def deps do
  [
    {:flamel, "~> 1.10.0"}
  ]
end
```

or mainline the latest:

```elixir
def deps do
  [
    {:flamel, github: "themusicman/flamel", branch: "main"}
  ]
end
```

## Examples

### Utility

`try_and_return` can be used with a function that throws and exception when you
want to use that function in a `with` statement.

```elixir
Flamel.try_and_return(fn -> :ok end) == :ok

Flamel.try_and_return(fn -> raise "error" end, {:ok, :default_value}) == {:ok, :default_value}
```

`wrap` function assists with wrapping a value in a tuple.

```elixir
Flamel.wrap(:ok, []) == {:ok, []}

Flamel.wrap(:error, "error") == {:error, "error"}
```

There other wrap helper functions that can come in handy when working with
LiveView, Genservers and the like that use `wrap/2` under the hood. These
functions are great for use when piping.

```elixir
import Flamel.Wrap

ok(["apple", "pear"]) == {:ok, ["apple", "pear"]}

socket
|> assign(:user, user)
|> ok()

socket
|> assign(:user, user)
|> noreply()
```
The `ok/1`, `noreply/1` helper functions were inspired by this [tweet](https://twitter.com/germsvel/status/1744686958196973787).

`unwrap_*` functions assists with handling functions that return a value wrapped
in a tuple.

```elixir
Flamel.unwrap_ok!({:ok, []}) == []

Flamel.unwrap_ok_or_nil({:error, "boom!"}) == nil
```

### Context

Ability to create a context that can be used to build function pipelines

```elixir
alias Flamel.Context

context =
  %Context{}
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

You don't have to use `%Flamel.Context{}` because `Flamel.Context` uses protocols. You can implement the `Flamel.Contextable` protocol for your own data type. Look at the interals of `Flamel.Retryable.Exponential` and `Flamel.Retryable.Linear` for an example.


### Chain (experimental)

A chain allows you to apply a sequence of functions to a value. If the function applied reutrns an `{:ok, value}` tuple then the value is updated but if the function returns an `{:error, reason, value}` tuple then the reason is set on the chain and no further functions will be applied to the value.

```elixir

def add_one(value) do
  {:ok, value + 1}
end

def minus_one_if_greater_than_one(value) when value > 1 do
  {:ok, value - 1}
end

def minus_one_if_greater_than_one(value) do
  {:ok, value}
end

1
|> Chain.new()
|> Chain.apply(&add_one/1)
|> Chain.apply(&minus_one_if_greater_than_one/1)
|> Chain.to_tuple() == {:ok, 1}
```

Chains can also be applied to an Enumerable:

```elixir

def add_one(value) do
  {:ok, value + 1}
end

Enum.map([1, 2, 3], Chain.curry(fn chain ->
  chain
  |> Chain.apply(&add_one/1)
  |> Chain.to_value()
end) == [2, 3, 4]
```



### Retryable (experimental)

Retryable functions that retry based on different strategies. Right now Linear and Exponential are the only 2 implemented but you can implement your own since the retry strategy uses two protocols (`Flamel.Contextable` and `Flamel.Retryable.Strategy`).

```elixir
strategy = %Flamel.Retryable.Linear{} # or Flamel.Retryable.linear()
Flamel.Retryable.try(strategy, fn strategy -> {:ok, "success", strategy} end)
{:ok, "success", strategy}
```

You can also assign values to the strategy since it implements `Flamel.Contextable`.

```elixir
strategy = %Flamel.Retryable.Exponential{} # or Flamel.Retryable.exponential()
import Flamel.Context

Flamel.Retryable.try(strategy, fn strategy ->
  case make_http_request(url, payload) do
    {:ok, result} ->
      {:ok, result, strategy}

    {:error, status, reason} ->
      {:error, reason, assign(strategy, :http_status, status)}
  end
end)

{:ok, "success", strategy}
```

There is a `Flamel.Retryable.Http` strategy but it currently just implements the Exponential strategy. The intent is to
change the retry interval based on the HTTP status but this is not implemented yet. PRs are welcome. ;)

### Delayed Task (experimental)

Executes an `Task.async` with a delay.

```elixir
task =
  Flamel.Task.delay(
    interval_in_milliseconds,
    fn ->
      do_something()
    end
  )

result = Task.await(task)
```



### Module

Detect if a module implements a behaviour.

```elixir
Flamel.Module.implements?(MyApp.Sender, MyApp.Worker) == true
```


### Predicates

```elixir
Flamel.blank?(%{}) == true

# present is the opposite of blank?
Flamel.present?(%{}) == false
```

### Conversions

```elixir
Flamel.to_boolean("Y") == true

Flamel.to_integer(nil) == ""

Flamel.to_integer(1) == 1

Flamel.to_float(nil) == 0.0

Flamel.to_float(1) == 1.0

Flamel.to_string(nil) == ""
```

### DateTime

```elixir
Flamel.Moment.to_datetime("2000-10-31T01:30:00.000-05:00") == ~U[2000-10-31 06:30:00.000Z]

Flamel.Moment.to_datetime(~N[2019-10-31 23:00:07]) == ~N[2019-10-31 23:00:07]

Flamel.Moment.to_date(~D[2000-10-31]) == ~D[2000-10-31]

Flamel.Moment.to_date("2000-10-31") == ~D[2000-10-31]

Flamel.Moment.to_iso8601(~U[2000-10-31 06:30:00.000Z]) == "2000-10-31T06:30:00.000Z"

Flamel.Moment.to_iso8601(~D[2019-10-31]) == "2019-10-31"
```

All of the to_* functions are implemented using [Protocols](https://hexdocs.pm/elixir/1.16/protocols.html). So you can implement you own behavior for types that do not already have implementations.

### Current Time Mocking

In your application code you will need to use `Flamel.Moment.CurrentTime`:

```elixir
now = Flamel.Moment.CurrentTime.utc_now()
```

Then if you want to mock the current time you can call `Flamel.Moment.CurrentTime.time_travel` in your test:

```elixir

now = DateTime.utc_now() |> DateTime.add(3600, :second)

Flamel.Moment.CurrentTime.time_travel(now) do
  # inside here the current time is mocked to the value you pass to time_travel
  assert Flamel.Moment.CurrentTime.utc_now() == now
end

# outside the block we are back to unmocked time
```

***IMPORTANT: This mocking only applies to the process that `Flamel.Moment.CurrentTime.time_travel` is called in***

### Number

```elixir
Flamel.Number.clamp(-10, 0) == 0

Flamel.Number.clamp(10, 0) == 10

Flamel.Number.clamp(10, 0, 5) == 5
```

### Maps/Structs

```elixir
Flamel.Map.atomize_keys(%{"first_name" => "Thomas", "dob" => "07/01/1981"}) == %{first_name: "Thomas", dob: "07/01/1981"}

map =
  Flamel.Map.assign(
    %{assigns: %{hobbies: ["playing"]}},
    :assigns,
    set: [name: "Osa"],
    push: [hobbies: ["soccer", "coloring"]]
  )

get_in(map, [:assigns, :hobbies]) == ["soccer", "coloring", "playing"]
get_in(map, [:assigns, :name]) == "Osa"

Flamel.Map.Indifferent.get(%{test: "value"}, "test") == "value"

Flamel.Map.Indifferent.get(%{test: "value"}, :test) == "value"

Flamel.Map.Safely.get(%Person{name: "Todd"}, &String.upcase(&1.name)) == "TODD"

Flamel.Map.Safely.get(%{name: "Todd"}, &String.upcase(&1.bad_field), "N/A") == "N/A"

Flamel.Map.put_if_present(%{name: "Todd"}, :name, nil) == %{name: "Todd"}

Flamel.Map.put_if_present(%{name: "Todd"}, :name, "Bob") == %{name: "Bob"}
```



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/flamel>.
