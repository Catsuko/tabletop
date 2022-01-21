defmodule Tabletop.MixProject do
  use Mix.Project

  def project do
    [
      app: :tabletop,
      version: "0.1.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "tabletop",
      description: "A library for creating board games with elixir.",
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["MIT"]  ,
      links: %{"GitHub" => "https://github.com/Catsuko/tabletop"}
    ]
  end
end
