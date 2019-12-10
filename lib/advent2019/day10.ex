defmodule Advent2019.Day10 do
  def part1(input \\ input()) do
    asteroids = find_asteroids(input)

    asteroids
    |> Enum.map(fn starting_position ->
      without_start =
        Enum.reject(asteroids, fn asteroid_position ->
          asteroid_position == starting_position
        end)

      without_start
      |> Enum.reject(&blocked?(&1, starting_position, without_start))
      |> Enum.count()
    end)
    |> Enum.max()
  end

  def part2(_input \\ input()) do
    :ok
  end

  defp find_asteroids(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {col, _} -> col == "#" end)
      |> Enum.map(fn {_col, x} -> {x, y} end)
    end)
  end

  defp blocked?(position, starting_position, asteroids) do
    points = line_points(position, starting_position)

    asteroids
    |> Enum.reject(fn asteroid_position -> asteroid_position == position end)
    |> Enum.filter(fn point -> point in points end)
    |> Enum.empty?()
    |> Kernel.not()
  end

  defp line_points(position, starting_position) do
    {position_x, position_y} = position
    {starting_position_x, starting_position_y} = starting_position

    for x <- position_x..starting_position_x,
        y <- position_y..starting_position_y,
        {x, y} != position,
        on_line?(position, starting_position, x, y) do
      {x, y}
    end
  end

  defp on_line?(position, starting_position, x, y) do
    {position_x, position_y} = position
    {starting_position_x, starting_position_y} = starting_position

    (position_x - starting_position_x) * (position_y - y) ==
      (position_x - x) * (position_y - starting_position_y)
  end

  defp input() do
    Advent2019.Utils.priv_file("day10.txt")
  end
end
