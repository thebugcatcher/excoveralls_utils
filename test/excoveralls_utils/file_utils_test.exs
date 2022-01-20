defmodule ExCoverallsUtils.FileUtilsTest do
  use ExUnit.Case

  alias ExCoverallsUtils.FileUtils

  describe "ls_r!/1" do
    test "returns expected path for a nested set of directories and files" do
      expected_result = [
        "./test/examples/file_utils_test/file1",
        "./test/examples/file_utils_test/file2",
        "./test/examples/file_utils_test/dir1/dir2/file4",
        "./test/examples/file_utils_test/dir1/file3"
      ]

      path = "./test/examples/file_utils_test"

      assert FileUtils.ls_r!(path) == expected_result
    end

    test "returns empty list if invalid file path" do
      path = "./invalid/file/path/super/improbable/to/exist"

      assert FileUtils.ls_r!(path) == []
    end
  end
end
