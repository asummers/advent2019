defmodule Advent2019.Day6 do
  def part1(input \\ input()) do
    {graph, _} = graph(input)

    graph
    |> :digraph.vertices()
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

  def part2(input \\ input()) do
    {_, graph} = graph(input)

    path_length =
      graph
      |> :digraph.get_path("YOU", "SAN")
      |> Enum.count()

    path_length - 3
  end

  defp graph(input) do
    directed_graph = :digraph.new()
    undirected_graph = :digraph.new()

    Enum.each(input, fn line ->
      [from, to] =
        line
        |> String.trim()
        |> String.split(")")

      :digraph.add_vertex(directed_graph, from)
      :digraph.add_vertex(directed_graph, to)
      :digraph.add_edge(directed_graph, from, to)

      :digraph.add_vertex(undirected_graph, from)
      :digraph.add_vertex(undirected_graph, to)
      :digraph.add_edge(undirected_graph, from, to)
      :digraph.add_edge(undirected_graph, to, from)
    end)

    {directed_graph, undirected_graph}
  end

  defp input() do
    Advent2019.Utils.priv_file_lines("day6.txt")
  end
end
