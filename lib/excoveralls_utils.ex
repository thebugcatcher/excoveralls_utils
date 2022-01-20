defmodule ExCoverallsUtils do
  @moduledoc """
  Documentation for `ExCoverallsUtils`.
  """

  alias __MODULE__.{FileUtils, MagicComment}

  def replace_magic_comments!(path) do
    path
    |> FileUtils.ls_r!()
    |> Enum.filter(&is_elixir_file/1)
    |> Enum.each(&replace_magic_comments_in_file!/1)
  end

  defp replace_magic_comments_in_file!(file) do
    replaced_contents =
      file
      |> File.read!()
      |> MagicComment.delete_due_ignores()

    File.write!(file, replaced_contents)
  end

  defp is_elixir_file(file_path) do
    file_path =~ ~r/.ex$/ or file_path =~ ~r/.exs$/
  end
end
