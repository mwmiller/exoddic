defmodule Exoddic.Mixfile do
  use Mix.Project

  def project do
    [app: :exoddic,
     version: "1.0.3",
     elixir: "~> 1.2",
     name: "Exoddic",
     source_url: "https://github.com/mwmiller/exoddic",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    [
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:power_assert, "~> 0.0.8", only: :test},
    ]
  end
  defp description do
    """
    Odds and probability handling and conversions
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README*", "LICENSE*", ],
     maintainers: ["Matt Miller"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mwmiller/exoddic",}
    ]
  end

end
