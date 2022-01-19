defmodule ExCoverallsUtilsTest do
  use ExUnit.Case
  doctest ExCoverallsUtils

  describe "config/0" do
    test "returns current config" do
      assert ExCoverallsUtils.config() == nil
    end
  end
end
