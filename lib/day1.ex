defmodule Day1 do
  @doc """
      iex> Day1.part1([12])
      2

      iex> Day1.part1([14])
      2

      iex> Day1.part1([1969])
      654

      iex> Day1.part1([100756])
      33583
  """
  def part1(input \\ input()) do
    input
    |> Enum.map(&part1_fuel/1)
    |> Enum.sum()
  end

  @doc """
      iex> Day1.part2([14])
      2

      iex> Day1.part2([1969])
      966

      iex> Day1.part2([100756])
      50346
  """
  def part2(input \\ input()) do
    input
    |> Enum.map(&part2_fuel/1)
    |> Enum.sum()
  end

  defp part1_fuel(mass) do
    max(0, floor(mass / 3) - 2)
  end

  defp part2_fuel(mass) when mass <= 0, do: 0

  defp part2_fuel(mass) do
    fuel = part1_fuel(mass)
    fuel_fuel = part2_fuel(fuel)

    fuel + fuel_fuel
  end

  defp input do
    :advent2019
    |> :code.priv_dir()
    |> Path.join("day1.txt")
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.to_integer()
    end)
  end
end
