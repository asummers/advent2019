defmodule Advent2019.Day8 do
  @width 25
  @height 6

  def part1(input \\ input()) do
    row = Enum.min_by(input, fn chunk -> row_count(chunk, 0) end)

    row_count(row, 1) * row_count(row, 2)
  end

  def part2(input \\ input()) do
    input
    |> Enum.reverse()
    |> Enum.reduce(List.duplicate(2, @width * @height), fn chunk, pixels ->
      chunk
      |> Enum.zip(pixels)
      |> Enum.map(fn {top, bottom} ->
        if top == 2 do
          bottom
        else
          top
        end
      end)
    end)
    |> Enum.chunk_every(@width)
    |> Enum.map_join("\n", fn chunk ->
      Enum.map_join(chunk, "  ", fn n ->
        case n do
          0 -> "_"
          1 -> "X"
        end
      end)
    end)
    |> IO.puts()
  end

  defp row_count(row, m) do
    row
    |> Enum.filter(fn n -> n == m end)
    |> Enum.count()
  end

  defp input() do
    "day8.txt"
    |> Advent2019.Utils.priv_file()
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.chunk_every(@width * @height)
    |> Enum.map(fn digits ->
      Enum.map(digits, fn n ->
        n
        |> String.trim()
        |> String.to_integer()
      end)
    end)
  end
end
