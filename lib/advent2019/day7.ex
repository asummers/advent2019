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
      for phase1 <- 0..4,
          phase2 <- 0..4,
          phase3 <- 0..4,
          phase4 <- 0..4,
          phase5 <- 0..4 do
        phases = [phase1, phase2, phase3, phase4, phase5]

        {phases, process_phases(phases, input)}
      end
      |> Enum.sort_by(fn {_, output} -> output end, &>=/2)
      |> Enum.filter(fn {phases, _} ->
        phases |> Enum.uniq() |> Enum.sort() == Enum.sort(phases)
      end)
      |> Enum.max_by(fn {_, output} -> output end)

    max
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
    0
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
