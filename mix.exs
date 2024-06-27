defmodule Flamel.MixProject do
  use Mix.Project

  @source_url "https://github.com/themusicman/flamel"
  @version "1.9.1"

  def project do
    [
      app: :flamel,
      version: @version,
      elixir: "~> 1.13",
      consolidate_protocols: Mix.env() != :test,
      package: package(),
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: [:mix]
      ]
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
      {:ecto, "~> 3.0"},
      {:styler, "~> 0.11", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.16.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:gettext, ">= 0.0.0", only: [:dev], runtime: false},
      {:sobelow, ">= 0.0.0", only: [:dev], runtime: false},
      {:mix_audit, ">= 0.0.0", only: [:dev], runtime: false}
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
