defmodule ZStream.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :z_stream,
      version: @version,
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: dialyzer(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "ZStream",
      docs: docs(),
      aliases: aliases(),
      preferred_cli_env: preferred_cli_env(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(_), do: ["lib"]

  defp dialyzer do
    [
      plt_local_path: "priv/plts/project.plt",
      plt_core_path: "priv/plts/core.plt",
      plt_add_apps: [:ex_unit, :mix]
    ]
  end

  defp description do
    """
    Compress and decompress data using various algorithms.
    """
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: "https://github.com/coherentpath/z_stream",
      authors: ["Nicholas Sweeting"]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Nicholas Sweeting"],
      links: %{"GitHub" => "https://github.com/coherentpath/z_stream"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [
      setup: [
        "local.hex --if-missing --force",
        "local.rebar --if-missing --force",
        "deps.get"
      ],
      ci: [
        "setup",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "test",
        "dialyzer --format github",
        "sobelow --config"
      ]
    ]
  end

  # Specifies the preferred env for mix commands.
  defp preferred_cli_env do
    [
      ci: :test
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30.8", only: :dev, runtime: false},
      {:ezstd, "~> 1.1"},
      {:host_triple, "~> 0.1.0"},
      {:lz4,
       git: "https://github.com/rabbitmq/lz4-erlang",
       ref: "100296252d31cc4847ba35d0c8efae3569bd66cb",
       manager: :make},
      {:sobelow, "~> 0.13.0", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 1.0", only: [:dev, :test]}
    ]
  end
end
