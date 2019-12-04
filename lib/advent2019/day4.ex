defmodule Advent2019.Day4 do
  def part1(input \\ input()) do
    input
    |> Enum.filter(&monotonic?/1)
    |> Enum.filter(&adjacent_same?/1)
    |> Enum.count()
  end

  @doc """
      iex> Advent2019.Day4.part2([112233])
      1

      iex> Advent2019.Day4.part2([123444])
      0

      iex> Advent2019.Day4.part2([111122])
      1
  """
  def part2(input \\ input()) do
    input
    |> Enum.filter(&monotonic?/1)
    |> Enum.filter(&adjacent_same?/1)
    |> Enum.filter(&smaller_group?/1)
    |> Enum.count()
  end

  defp monotonic?(n) do
    {_, monotonic?} =
      n
      |> Integer.digits()
      |> Enum.reduce({-1, true}, fn digit, {previous_digit, monotonic?} ->
        {digit, monotonic? && previous_digit <= digit}
      end)

    monotonic?
  end

  defp adjacent_same?(n) do
    {_, adjacent_same?} =
      n
      |> Integer.digits()
      |> Enum.reduce({-1, false}, fn digit, {previous_digit, adjacent_same?} ->
        {digit, adjacent_same? || previous_digit == digit}
      end)

    adjacent_same?
  end

  defp smaller_group?(n) do
    {previous_digits, smaller_group?} =
      n
      |> Integer.digits()
      |> Enum.reduce({[-1], false}, fn digit,
                                       {previous_digits = [previous_digit | _], smaller_group?} ->
        if digit == previous_digit do
          {[digit | previous_digits], smaller_group?}
        else
          {[digit], smaller_group? || new_smaller_group?(previous_digits)}
        end
      end)

    smaller_group? || new_smaller_group?(previous_digits)
  end

  defp new_smaller_group?(previous_digits) do
    1 < Enum.count(previous_digits) && Enum.count(previous_digits) < 3
  end

  defp input do
    138_307..654_504
  end
end
