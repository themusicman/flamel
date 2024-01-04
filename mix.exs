defmodule Flamel.MixProject do
  use Mix.Project

  @source_url "https://github.com/themusicman/flamel"
  @version "1.0.0"

  def project do
    [
      app: :flamel,
      version: @version,
      elixir: "~> 1.13",
      consolidate_protocols: Mix.env() != :test,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def package do
    [
      description: "A questionable bag of helper functions",
      maintainers: ["Thomas Brewer"],
      contributors: ["Thomas Brewer"],
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        LICENSE: [title: "License"],
        "README.md": [title: "Readme"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      api_reference: false,
      formatters: ["html"]
    ]
  end
end
