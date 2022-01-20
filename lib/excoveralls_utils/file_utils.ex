defmodule ExCoverallsUtils.FileUtils do
  @moduledoc """
  File helpers for ExCoverallsUtils
  """

  def ls_r!(path \\ ".") do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        path
        |> File.ls!()
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r!/1)
        |> Enum.concat()

      true ->
        []
    end
  end
end
