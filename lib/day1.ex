defmodule Day1 do
  @doc """
      iex> Day1.fuel(12)
      2

      iex> Day1.fuel(14)
      2

      iex> Day1.fuel(1969)
      654

      iex> Day1.fuel(100756)
      33583
  """
  def fuel(mass) do
    max(0, floor(mass / 3) - 2)
  end

  @doc """
      iex> Day1.part2_fuel(14)
      2

      iex> Day1.part2_fuel(1969)
      966

      iex> Day1.part2_fuel(100756)
      50346
  """
  def part2_fuel(mass) when mass <= 0, do: 0

  def part2_fuel(mass) do
    fuel = fuel(mass)
    fuel_fuel = part2_fuel(fuel)

    fuel + fuel_fuel
  end

  def part1 do
    input()
    |> Enum.map(fn mass ->
      fuel(mass)
    end)
    |> Enum.sum()
  end

  def part2 do
    input()
    |> Enum.map(fn mass ->
      part2_fuel(mass)
    end)
    |> Enum.sum()
  end

  defp input do
    :advent2019
    |> :code.priv_dir()
    |> Path.join("day1.txt")
    |> File.stream!()
    |> Enum.map(fn line ->
      {mass, ""} =
        line
        |> String.trim()
        |> Integer.parse()

      mass
    end)
  end
end
