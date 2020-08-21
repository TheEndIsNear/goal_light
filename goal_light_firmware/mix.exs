defmodule GoalLightFirmware.MixProject do
  use Mix.Project

  @app :goal_light_firmware
  @version "0.2.0"
  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :x86_64]

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
        plt_file: {:no_warn, "goal_light_firmware.plt"}
      ],
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.8"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GoalLightFirmware.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:git_hooks, "~> 0.5.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:credo, "~> 1.4.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0.2", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22.2", only: :dev, runtime: false},
      # Dependencies for all targets
      {:goal_light_ui, path: "../goal_light_ui", targets: @all_targets, env: Mix.env()},
      {:nerves, "~> 1.6.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:circuits_gpio, "~> 0.4"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_pack, "~> 0.2", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi, "~> 2.0.0-rc.0", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 2.0.0-rc.0", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 2.0.0-rc.0", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 2.0.0-rc.0", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 2.0.0-rc.0", runtime: false, targets: :rpi3a},
      {:nerves_system_rpi4, "~> 2.0.0-rc.0", runtime: false, targets: :rpi4},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
