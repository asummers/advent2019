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
    initial = Advent2019.Utils.to_indexed_map(input)

    phases(0, 4)
    |> Enum.map(fn phases ->
      Enum.reduce(phases, 0, fn phase, previous_output ->
        {_, [output | _]} = Advent2019.Intcode.process_intcode(initial, [phase, previous_output])
        output
      end)
    end)
    |> Enum.max()
  end

  defp phases(min, max) do
    for phase1 <- min..max,
        phase2 <- min..max,
        phase3 <- min..max,
        phase4 <- min..max,
        phase5 <- min..max,
        phases = [phase1, phase2, phase3, phase4, phase5],
        Enum.count(Enum.uniq(phases)) == Enum.count(phases) do
      phases
    end
  end

  @doc """
      iex> Advent2019.Day7.part2([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5])
      139629729

      iex> Advent2019.Day7.part2([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10])
      18216
  """
  def part2(input \\ input()) do
    initial = Advent2019.Utils.to_indexed_map(input)

    phases(5, 9)
    |> Enum.map(fn phases ->
      Stream.repeatedly(fn -> phases end)
      |> Enum.reduce_while({0, %{}}, fn phases, {previous_output, state} ->
        {output, state} =
          Enum.reduce(phases, {previous_output, state}, fn phase, {previous_output, state} ->
            process_phase(phase, initial, previous_output, state)
          end)

        if done?(state) do
          {:halt, output}
        else
          {:cont, {output, state}}
        end
      end)
    end)
    |> Enum.max()
  end

  defp done?(state) do
    state
    |> Map.values()
    |> Enum.any?(&is_nil/1)
  end

  defp process_phase(phase, initial, previous_output, state) do
    {input, {result, instruction_pointer}} =
      if Map.has_key?(state, phase) do
        {previous_output, Map.get(state, phase)}
      else
        {[phase, previous_output], {initial, 0}}
      end

    case Advent2019.Intcode.process_intcode(
           result,
           instruction_pointer,
           input,
           [previous_output],
           true,
           0
         ) do
      {_, [output | _]} ->
        {output, Map.put(state, phase, nil)}

      {result, instruction_pointer, output} ->
        {output, Map.put(state, phase, {result, instruction_pointer})}
    end
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
