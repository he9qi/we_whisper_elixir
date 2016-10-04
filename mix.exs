defmodule WeWhisper.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :we_whisper,
     version: @version,
     package: package,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/he9qi/we_whisper_elixir",
     homepage_url: "https://github.com/he9qi/we_whisper_elixir",
     description: description,
     deps: deps,
     docs: docs,
     elixirc_paths: elixirc_paths(Mix.env),
     test_coverage: [tool: ExCoveralls]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  defp deps do
    [ {:secure_random, "~> 0.5"},
      {:mock, "~> 0.1.1", only: :test},
      {:earmark, "~>0.1", only: :dev},
      {:ex_doc, "~>0.1", only: :dev}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end

  defp description do
    "An Elixir Wrapper for Wechat Message Encryption."
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Qi He"],
      licenses: ["MIT"],
      links: %{"Github": "https://github.com/he9qi/we_whisper_elixir"}]
  end
end
