defmodule SiteReboot.MixProject do
  use Mix.Project

  def project do
    [
      app: :site_reboot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SiteReboot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.10"},
      {:jason, "~> 1.2"},
      {:quantum, "~> 3.0"},
      {:maru, "~> 0.13.2"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
