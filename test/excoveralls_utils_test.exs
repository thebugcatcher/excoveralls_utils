defmodule ExCoverallsUtilsTest do
  use ExUnit.Case

  @source_file "./test/examples/magic_comments_example.ex"
  @expected_destination "./test/examples/magic_comments_expected_post_test.ex"
  @destination_file "./magic_comments_gitignored.ex"

  describe "replace_magic_comments!/1" do
    setup do
      prepare_file()

      :ok
    end

    test "replaces magic comments in all files" do
      assert File.read!(@destination_file) == File.read!(@source_file)

      ExCoverallsUtils.replace_magic_comments!(@destination_file)

      refute File.read!(@destination_file) == File.read!(@source_file)
      assert File.read!(@destination_file) == File.read!(@expected_destination)
    end
  end

  defp prepare_file do
    File.copy!(@source_file, @destination_file)

    on_exit(fn ->
      File.rm!(@destination_file)
    end)
  end
end
