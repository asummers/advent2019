defmodule Advent2019.Day1 do
  @doc """
      iex> Advent2019.Day1.part1([12])
      2

      iex> Advent2019.Day1.part1([14])
      2

      iex> Advent2019.Day1.part1([1969])
      654

      iex> Advent2019.Day1.part1([100756])
      33583
  """
  def part1(input \\ input()) do
    input
    |> Stream.map(&part1_fuel/1)
    |> Enum.sum()
  end

  @doc """
      iex> Advent2019.Day1.part2([14])
      2

      iex> Advent2019.Day1.part2([1969])
      966

      iex> Advent2019.Day1.part2([100756])
      50346
  """
  def part2(input \\ input()) do
    input
    |> Stream.map(&part2_fuel(&1, 0))
    |> Enum.sum()
  end

  defp part1_fuel(mass) do
    max(0, div(mass, 3) - 2)
  end

  defp part2_fuel(mass, total) when mass <= 0, do: total

  defp part2_fuel(mass, total) do
    fuel = part1_fuel(mass)
    part2_fuel(fuel, total + fuel)
  end

  defp input do
    "day1.txt"
    |> Advent2019.Utils.priv_file_lines()
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.to_integer()
    end)
  end
end
