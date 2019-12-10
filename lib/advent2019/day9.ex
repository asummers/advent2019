defmodule Advent2019.Day9 do
  @doc """
      iex> Advent2019.Day9.part1([104,1125899906842624,99])
      1125899906842624

      iex> Advent2019.Day9.part1([1102,34915192,34915192,7,4,7,99,0])
      1219070632396864

      iex> Advent2019.Day9.part1([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
      99
  """
  def part1(input \\ input()) do
    initial = Advent2019.Utils.to_indexed_map(input)

    {_, [output | _]} = Advent2019.Opcode.process_opcode(initial, 0, 1, [], false, 0)
    output
  end

  def part2(input \\ input()) do
    initial = Advent2019.Utils.to_indexed_map(input)

    {_, [output | _]} = Advent2019.Opcode.process_opcode(initial, 0, 2, [], false, 0)
    output
  end

  defp input() do
    "day9.txt"
    |> Advent2019.Utils.priv_file()
    |> String.trim()
    |> String.trim_trailing("-")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
