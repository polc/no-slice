defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :no_slice,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {NoSlice.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp releases do
    [
      default: [
        include_executables_for: [:unix]
      ]
    ]
  end

  defp aliases do
    [
      start: ["ecto.setup", "phx.server"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repository/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      {:absinthe, "~> 1.4"},
      {:absinthe_relay, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:bcrypt_elixir, "~> 2.0"},
      {:cors_plug, "~> 2.0"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dataloader, "~> 1.0.0"},
      {:ecto_sql, "~> 3.0"},
      {:ex_crypto, "~> 0.10.0"},
      {:jason, "~> 1.0"},
      {:joken, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix, "~> 1.4.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
