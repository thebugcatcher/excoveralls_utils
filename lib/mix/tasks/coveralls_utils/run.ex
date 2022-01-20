defmodule Mix.Tasks.CoverallsUtils.Run do
  @moduledoc """
  Runs `mix coveralls` tasks with due date ignores
  """
  use Mix.Task

  @shortdoc "Runs `mix coveralls` tasks with due date ignores"

  @nimble_options [
    task: [
      type: :string,
      required: true
    ],
    path: [
      type: :string,
      required: true
    ]
  ]

  @options [strict: [task: :string, path: :string]]

  def run(args) do
    {strict, _, _} = OptionParser.parse(args, @options)

    [task: task, path: path] = validate_strict!(strict)

    ExCoverallsUtils.replace_magic_comments!(path)

    System.shell("mix #{task}")
  end

  defp validate_strict!(strict) do
    case NimbleOptions.validate(strict, @nimble_options) do
      {:ok, values} -> values
      {:error, %{message: message}} -> raise "Error: \n #{message}"
    end
  end
end
