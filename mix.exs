defmodule ExCoverallsUtils.MixProject do
  use Mix.Project

  @repo_url "https://github.com/thebugcatcher/excoveralls_utils"
  @version "0.0.1"
  @elixir "~> 1.12"

  def project do
    [
      aliases: aliases(),
      app: :excoveralls_utils,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:ex_unit]
      ],
      elixir: @elixir,
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: @version,
      warn_test_pattern: "excoveralls_utils{,_web}/**/*.{ex,exs}"
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ssl]
    ]
  end

  defp deps do
    [
      {:nimble_options, "~> 0.3.7"},

      ## Test and Dev dependencies
      {:credo, "~> 1.5.6", only: :dev},
      {:dialyxir, "~> 1.1.0", only: ~w[dev test]a, runtime: false},
      {:excoveralls, "~> 0.14.2", only: ~w[dev test]a},
      {:ex_doc, "~> 0.25.5", only: :dev, runtime: false},
      {:faker, "~> 0.16.0", only: ~w[dev test]a}
    ]
  end

  defp elixirc_paths(env) when env in ~w[test]a, do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "priv"],
      description: "Utilities for ExCoveralls",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url
      }
    ]
  end

  defp aliases, do: []
end

# Use the right OTP version
case System.otp_release() do
  "24" -> :ok
  other -> raise "you're running OTP #{other}. This project requires OTP 24"
end
