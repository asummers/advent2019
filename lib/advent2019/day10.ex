defmodule Advent2019.Day10 do
  def part1(input \\ input()) do
    asteroids = find_asteroids(input)

    {_position, count} = position_visible_count(asteroids)

    count
  end

  def part2(input \\ input()) do
    asteroids = find_asteroids(input)

    {point, _count} = position_visible_count(asteroids)

    {x, y} =
      asteroids
      |> asteroids_by_bearing(point)
      |> destroy_lasers([])
      |> Enum.at(199)

    x * 100 + y
  end

  defp asteroids_by_bearing(asteroids, point) do
    asteroids
    |> Enum.reject(fn asteroid_position -> asteroid_position == point end)
    |> Enum.group_by(fn {x, y} -> bearing(point, x, y) end)
    |> Map.new(fn {radians_from_north, points} ->
      {radians_from_north, Enum.sort_by(points, &distance_from_point(point, &1))}
    end)
  end

  defp destroy_lasers(asteroids, previously_destroyed) when map_size(asteroids) == 0 do
    Enum.reverse(previously_destroyed)
  end

  defp destroy_lasers(asteroids, previously_destroyed) do
    {new_sorted, destroyed} =
      asteroids
      |> Enum.sort_by(fn {radians_from_north, _} -> radians_from_north end)
      |> Enum.reduce({asteroids, previously_destroyed}, &destroy/2)

    new_sorted
    |> Enum.reject(fn {_, remaining} -> Enum.empty?(remaining) end)
    |> Map.new()
    |> destroy_lasers(destroyed)
  end

  defp destroy({radians_from_north, [point | _]}, {state, previously_destroyed}) do
    new_state = Map.update!(state, radians_from_north, &tl/1)

    {new_state, [point | previously_destroyed]}
  end

  defp bearing(point, x, y) do
    {point_x, point_y} = point

    bearing =
      case :math.atan2(y - point_y, x - point_x) - 3 * :math.pi() / 2 do
        theta when theta >= 0 ->
          theta

        theta ->
          2 * :math.pi() + theta
      end

    if bearing < 0 do
      bearing + 2 * :math.pi()
    else
      bearing
    end
  end

  defp distance_from_point(point1, point2) do
    {point1_x, point1_y} = point1
    {point2_x, point2_y} = point2

    :math.sqrt(:math.pow(point1_x - point2_x, 2.0) + :math.pow(point1_y - point2_y, 2.0))
  end

  defp position_visible_count(asteroids) do
    asteroids
    |> Enum.map(fn starting_position ->
      without_start =
        Enum.reject(asteroids, fn asteroid_position ->
          asteroid_position == starting_position
        end)

      count =
        without_start
        |> Enum.reject(&blocked?(&1, starting_position, without_start))
        |> Enum.count()

      {starting_position, count}
    end)
    |> Enum.max_by(fn {_, count} -> count end)
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
    line_points = line_points(position, starting_position)

    asteroids
    |> Enum.reject(fn asteroid_position -> asteroid_position == position end)
    |> Enum.filter(fn point -> point in line_points end)
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

  defp input do
    Advent2019.Utils.priv_file("day10.txt")
  end
end
