# Flamel

[![Elixir CI](https://github.com/themusicman/flamel/actions/workflows/elixir.yml/badge.svg)](https://github.com/themusicman/flamel/actions/workflows/elixir.yml)

This package is a bag of helper functions. Some might be questionable but they are what they are so use them as you will.

## Installation

If [available in Hex](https://hex.pm/packages/flamel), the package can be installed
by adding `flamel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:flamel, "~> 1.0.0"}
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

def perform_action(%Context{halt: true}) do
  # do nothing
  context
end

def perform_action(%Context{assigns: %{user: user}} = context) do
  # Do something
  Context.assign(context, %{action_performed_by: user, action_performed?: true})
end

```

You don't have to use `%Flamel.Context{}` because `Flamel.Context` uses protocols. You can implement the `Flamel.Contextable` protocol for your own data type. Look at the interals of `Flamel.Retryable.Exponential` and `Flamel.Retryable.Linear` for an example. 

### Retryable

Retryable functions that retry based on different strategies. Right now Linear and Exponential at the only 2 implemented but you can implement your own since the retry strategy uses two protocols (`Flamel.Contextable` and `Flamel.Retryable.Strategy`). 

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

### Utility 

```elixir
Flamel.try_and_return(fn -> :ok end) == :ok

Flamel.try_and_return(fn -> raise "error" end, {:ok, :default_value}) == {:ok, :default_value}

Flamel.unwrap_ok!({:ok, []}) == []

Flamel.unwrap_ok_or_nil({:error, "boom!"}) == nil

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

### Maps/Structs

```elixir
Flamel.Map.atomize_keys(%{"first_name" => "Thomas", "dob" => "07/01/1981"}) == %{first_name: "Thomas", dob: "07/01/1981"}

Flamel.Map.Indifferent.get(%{test: "value"}, "test") == "value"

Flamel.Map.Indifferent.get(%{test: "value"}, :test) == "value"

Flamel.Map.Safely.get(%Person{name: "Todd"}, &String.upcase(&1.name)) == "TODD"

Flamel.Map.Safely.get(%{name: "Todd"}, &String.upcase(&1.bad_field), "N/A") == "N/A"
```

All of the to_* functions are implemented using [Protocols](https://hexdocs.pm/elixir/1.16/protocols.html). So you can implement you own behavior for types that do not already have implementations.


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/flamel>.

