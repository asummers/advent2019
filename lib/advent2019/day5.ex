defmodule Advent2019.Day5 do
  def part1(input \\ input()) do
    {_, [diagnostic_code | _]} =
      input
      |> Advent2019.Utils.to_indexed_map()
      |> Advent2019.Intcode.process_intcode()

    diagnostic_code
  end

  def part2(input \\ input()) do
    {_, [diagnostic_code | _]} =
      input
      |> Advent2019.Utils.to_indexed_map()
      |> Advent2019.Intcode.process_intcode(5)

    diagnostic_code
  end

  defp input() do
    "day5.txt"
    |> Advent2019.Utils.priv_file()
    |> String.trim()
    |> String.trim_trailing("-")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
