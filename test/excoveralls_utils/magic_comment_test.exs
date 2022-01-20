defmodule ExCoverallsUtils.MagicCommentTest do
  use ExUnit.Case

  alias ExCoverallsUtils.MagicComment

  describe "delete_due_ignores/1" do
    test "successfully removes magic comments past the due date" do
      yesterday = Date.utc_today() |> Date.add(-1) |> Date.to_iso8601()
      tomorrow = Date.utc_today() |> Date.add(1) |> Date.to_iso8601()

      string = """
      defmodule X do
        # coveralls-ignore-start @due_date: #{yesterday}
        def fun, do: IO.puts "Hello World"
        # coveralls-ignore-end

        # coveralls-ignore-start @due_date: #{tomorrow}
        def dun, do: IO.puts "Hello Universe"
        # coveralls-ignore-end

        # coveralls-ignore-start @due_date: #{yesterday}
        def hun, do: IO.puts "Hello Multiverse"
        # coveralls-ignore-end
      end
      """

      expected_string = """
      defmodule X do
        def fun, do: IO.puts "Hello World"

        # coveralls-ignore-start @due_date: #{tomorrow}
        def dun, do: IO.puts "Hello Universe"
        # coveralls-ignore-end

        def hun, do: IO.puts "Hello Multiverse"
      end
      """

      assert MagicComment.delete_due_ignores(string) == expected_string
    end

    test "raises error if a magic comment doesn't have a due date" do
      yesterday = Date.utc_today() |> Date.add(-1) |> Date.to_iso8601()
      tomorrow = Date.utc_today() |> Date.add(1) |> Date.to_iso8601()

      string = """
      defmodule X do
        # coveralls-ignore-start @due_date: #{yesterday}
        def fun, do: IO.puts "Hello World"
        # coveralls-ignore-end

        # coveralls-ignore-start @due_date: #{tomorrow}
        def dun, do: IO.puts "Hello Universe"
        # coveralls-ignore-end

        # coveralls-ignore-start
        def hun, do: IO.puts "Hello Multiverse"
        # coveralls-ignore-end
      end
      """

      assert_raise(RuntimeError, ~r/Expected a due date/, fn ->
        MagicComment.delete_due_ignores(string)
      end)
    end
  end
end
