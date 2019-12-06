defmodule Advent2019.Day6 do
  def part1(input \\ input()) do
    graph = graph(input)

    graph
    |> :digraph.vertices()
    |> Enum.sort()
    |> Enum.map(fn vertex ->
      case :digraph.get_path(graph, "COM", vertex) do
        false ->
          0

        path ->
          Enum.count(path) - 1
      end
    end)
    |> Enum.sum()
  end

  defp graph(input) do
    Enum.reduce(input, :digraph.new(), fn line, graph ->
      [from, to] =
        line
        |> String.trim()
        |> String.split(")")

      :digraph.add_vertex(graph, from)
      :digraph.add_vertex(graph, to)
      :digraph.add_edge(graph, from, to)

      graph
    end)
  end

  def part2(input \\ input()) do
    0
  end

  defp input() do
    Advent2019.Utils.priv_file_lines("day6.txt")
  end
end
