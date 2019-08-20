defmodule TgScrumPoker.MixProject do
  use Mix.Project

  def project do
    [
      app: :tg_scrum_poker,
      version: "0.1.0",
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
      {:ex_gram, "~> 0.7.1"},
      {:jason, "~> 1.1"},
      {:gproc, "0.8.0"}
    ]
  end
end
