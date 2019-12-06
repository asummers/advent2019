defmodule Advent2019.Day2 do
  @doc """
      iex> Advent2019.Day2.part1([1, 0, 0, 0, 99])
      2

      iex> Advent2019.Day2.part1([2, 3, 0, 3, 99])
      2

      iex> Advent2019.Day2.part1([2, 4, 4, 5, 99, 0])
      2

      iex> Advent2019.Day2.part1([1, 1, 1, 4, 99, 5, 6, 0, 99])
      30

      iex> Advent2019.Day2.part1([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50])
      3500
  """
  def part1(input \\ input(12, 2)) do
    {result, _} =
      input
      |> Enum.with_index()
      |> Map.new(fn {v, k} -> {k, v} end)
      |> Advent2019.Opcode.process_opcode(0)

    result
  end

  def part2() do
    result =
      for noun <- 1..99,
          verb <- 1..99 do
        {{noun, verb}, part1(input(noun, verb))}
      end

    {{noun, verb}, _} = Enum.find(result, fn {_, n} -> n == 19_690_720 end)
    100 * noun + verb
  end

  defp input(noun, verb) do
    "day2.txt"
    |> Advent2019.Utils.priv_file()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end
end
