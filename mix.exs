defmodule TgScrumPoker.MixProject do
  use Mix.Project

  def project do
    [
      app: :tg_scrum_poker,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TgScrumPoker, []},
      extra_applications: [:logger, :gproc]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.21"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.16"},
      {:jason, "~> 1.0.0"},
      {:gproc, "0.8.0"}
    ]
  end
end
