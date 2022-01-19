defmodule ExCoverallsUtils do
  @moduledoc """
  Documentation for `ExCoverallsUtils`.
  """

  def config, do: Application.get_env(:excoveralls_utils, __MODULE__)
end
