defmodule GoalLightUi.MixProject do
  use Mix.Project

  def project do
    [
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true,
        plt_file: {:no_warn, "goal_light_ui.plt"}
      ],
      app: :goal_light_ui,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GoalLightUi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:git_hooks, "~> 0.5.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:credo, "~> 1.4.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0.2", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22.2", only: :dev, runtime: false},
      {:phoenix, "~> 1.5.4"},
      {:phoenix_live_view, "~> 0.14.4"},
      {:floki, "~> 0.27.0", only: :test},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_reload, "~> 1.2.4", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2.7"},
      {:telemetry_metrics, "~> 0.5.0"},
      {:telemetry_poller, "~> 0.5.1"},
      {:gettext, "~> 0.18.1"},
      {:jason, "~> 1.2.1"},
      {:plug_cowboy, "~> 2.3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end
end
