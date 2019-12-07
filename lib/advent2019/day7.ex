defmodule Advent2019.Day7 do
  @doc """
      iex> Advent2019.Day7.part1([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0])
      43210

      iex> Advent2019.Day7.part1([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0])
      54321

      iex> Advent2019.Day7.part1([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0])
      65210
  """
  def part1(input \\ input()) do
    {_, max} =
      phases(0, 4)
      |> Enum.map(fn phases -> {phases, process_phases(phases, input)} end)
      |> Enum.max_by(fn {_, output} -> output end)

    max
  end

  defp phases(min, max) do
    for phase1 <- min..max,
        phase2 <- min..max,
        phase3 <- min..max,
        phase4 <- min..max,
        phase5 <- min..max do
      [phase1, phase2, phase3, phase4, phase5]
    end
    |> Enum.filter(fn {phases, _} ->
      phases |> Enum.uniq() |> Enum.sort() == Enum.sort(phases)
    end)
  end

  def process_phases(phases, input) do
    Enum.reduce(phases, 0, fn phase, previous_output ->
      {_, [output | _]} =
        input
        |> Advent2019.Utils.to_indexed_map()
        |> Advent2019.Opcode.process_opcode(0, [phase, previous_output])

      output
    end)
  end

  def part2(input \\ input()) do
    phases(5, 9)
  end

  defp input() do
    "day7.txt"
    |> Advent2019.Utils.priv_file()
    |> String.split(",")
    |> Enum.map(fn n ->
      n
      |> String.trim()
      |> String.to_integer()
    end)
  end
end
