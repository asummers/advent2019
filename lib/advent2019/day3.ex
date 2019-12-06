defmodule Advent2019.Day3 do
  @doc """
      iex> Advent2019.Day3.part1(["R8,U5,L5,D3", "U7,R6,D4,L4"])
      6

      iex> Advent2019.Day3.part1(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
      159

      iex> Advent2019.Day3.part1(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"])
      135
  """
  def part1([wire1_input, wire2_input] \\ input()) do
    wire1_points =
      wire1_input
      |> wire_points()
      |> MapSet.new(fn {point, _distance_traveled} -> point end)

    wire2_points =
      wire2_input
      |> wire_points()
      |> MapSet.new(fn {point, _distance_traveled} -> point end)

    {closest_x, closest_y} =
      wire1_points
      |> MapSet.intersection(wire2_points)
      |> Enum.min_by(fn {x, y} -> abs(x) + abs(y) end)

    closest_x + closest_y
  end

  @doc """
      iex> Advent2019.Day3.part2(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
      610

      iex> Advent2019.Day3.part2(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"])
      410
  """
  def part2([wire1_input, wire2_input] \\ input()) do
    wire1_points_and_distances =
      wire1_input
      |> wire_points()
      |> Map.new()

    wire1_points =
      wire1_points_and_distances
      |> Map.keys()
      |> MapSet.new()

    wire2_points_and_distances =
      wire2_input
      |> wire_points()
      |> Map.new()

    wire2_points =
      wire2_points_and_distances
      |> Map.keys()
      |> MapSet.new()

    wire1_points
    |> MapSet.intersection(wire2_points)
    |> Enum.map(fn point ->
      wire1_distance_traveled = Map.fetch!(wire1_points_and_distances, point)
      wire2_distance_traveled = Map.fetch!(wire2_points_and_distances, point)

      wire1_distance_traveled + wire2_distance_traveled
    end)
    |> Enum.min()
  end

  defp wire_points(input) do
    {_, points, _} =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.reduce({{0, 0}, [], 0}, fn direction,
                                         {{previous_x, previous_y}, points, distance_traveled} ->
        case direction do
          "R" <> distance ->
            distance = String.to_integer(distance)
            new_previous = {previous_x + distance, previous_y}

            new_points =
              Enum.map(0..distance, fn n ->
                {{previous_x + n, previous_y}, distance_traveled + n}
              end)

            {new_previous, points ++ new_points, distance_traveled + distance}

          "L" <> distance ->
            distance = String.to_integer(distance)
            new_previous = {previous_x - distance, previous_y}

            new_points =
              Enum.map(0..distance, fn n ->
                {{previous_x - n, previous_y}, distance_traveled + n}
              end)

            {new_previous, points ++ new_points, distance_traveled + distance}

          "U" <> distance ->
            distance = String.to_integer(distance)
            new_previous = {previous_x, previous_y + distance}

            new_points =
              Enum.map(0..distance, fn n ->
                {{previous_x, previous_y + n}, distance_traveled + n}
              end)

            {new_previous, points ++ new_points, distance_traveled + distance}

          "D" <> distance ->
            distance = String.to_integer(distance)
            new_previous = {previous_x, previous_y - distance}

            new_points =
              Enum.map(0..distance, fn n ->
                {{previous_x, previous_y - n}, distance_traveled + n}
              end)

            {new_previous, points ++ new_points, distance_traveled + distance}
        end
      end)

    points
    |> MapSet.new()
    |> MapSet.delete({{0, 0}, 0})
  end

  defp input do
    "day3.txt"
    |> Advent2019.Utils.priv_file_lines()
    |> Enum.to_list()
  end
end
