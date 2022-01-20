defmodule ExCoverallsUtils.MagicComment do
  @moduledoc """
  This module is responsible for managing magic comments that can be added
  for ExCoveralls.
  """

  @ignore_start "coveralls-ignore-start"
  @ignore_end "coveralls-ignore-end"

  def delete_due_ignores(string) when is_binary(string) do
    {collected, _} =
      string
      |> String.split("\n")
      |> Enum.reduce({[], false}, &iterator/2)

    Enum.join(collected, "\n")
  end

  defp iterator(line, {collected, ignore_started}) do
    cond do
      is_comment?(line) and ignore_started ->
        {
          collected,
          not has_coveralls_ignore_end?(line)
        }

      is_comment?(line) and has_coveralls_ignore_start?(line) ->
        ignore_due_date = parse_ignore_due_date!(line)

        if Date.diff(Date.utc_today(), ignore_due_date) >= 0 do
          {
            collected,
            true
          }
        else
          {
            collected ++ [line],
            false
          }
        end

      true ->
        {
          collected ++ [line],
          ignore_started
        }
    end
  end

  defp is_comment?(line), do: line =~ "#"

  defp has_coveralls_ignore_start?(line), do: line =~ @ignore_start

  defp has_coveralls_ignore_end?(line), do: line =~ @ignore_end

  @due_date_regex ~r/\@due_date\: (?<date>\d{4}-\d{2}-\d{2})/
  defp parse_ignore_due_date!(line) do
    case Regex.named_captures(@due_date_regex, line) do
      %{"date" => date} ->
        Date.from_iso8601!(date)

      _ ->
        raise """
        Expected a due date after #{@ignore_start} in iso8601 format:

        # #{@ignore_start} @due_date: YYYY-MM-DD
        """
    end
  end
end
