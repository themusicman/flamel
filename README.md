# Flamel

This package is a bag of helper functions. Some might be questionable but they are what they are so use them as you will.

## Installation

If [available in Hex](https://hex.pm/packages/flamel), the package can be installed
by adding `flamel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:flamel, "~> 0.1.0"}
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

```elixir
Flamel.try_and_return(fn -> :ok end) == :ok

Flamel.try_and_return(fn -> raise "error" end, {:ok, :default_value}) == {:ok, :default_value}

Flamel.unwrap_ok!({:ok, []}) == []

Flamel.blank?(%{}) == true

Flamel.present?(%{}) == false

Flamel.to_boolean("Y") == true

Flamel.Moment.to_datetime("2000-10-31T01:30:00.000-05:00") == ~U[2000-10-31 06:30:00.000Z]

Flamel.Moment.to_datetime(~N[2019-10-31 23:00:07]) == ~N[2019-10-31 23:00:07]

Flamel.Moment.to_date(~D[2000-10-31]) == ~D[2000-10-31]

Flamel.Moment.to_date(%{"day" => "01", "month" => "12", "year" => "2004"}) == ~D[2004-12-01]

Flamel.Moment.to_date("2000-10-31") == ~D[2000-10-31]

Flamel.Moment.to_iso8601(~U[2000-10-31 06:30:00.000Z]) == "2000-10-31T06:30:00.000Z"

Flamel.Moment.to_iso8601(~D[2019-10-31]) == "2019-10-31"
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/flamel>.

