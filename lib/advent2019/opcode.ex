defmodule Advent2019.Opcode do
  def process_opcode(initial, input \\ 1) do
    process_opcode(initial, 0, input, [], false)
  end

  def process_opcode(result, instruction_pointer, input, output, interrupt?) do
    case opcode(result, instruction_pointer) do
      [1 = _add, _param3_mode, param2_mode, param1_mode] ->
        value_1 = value(result, instruction_pointer + 1, param1_mode)
        value_2 = value(result, instruction_pointer + 2, param2_mode)
        destination = Map.get(result, instruction_pointer + 3)

        result
        |> Map.put(destination, value_1 + value_2)
        |> process_opcode(instruction_pointer + 4, input, output, interrupt?)

      [2 = _multiply, _param3_mode, param2_mode, param1_mode] ->
        value_1 = value(result, instruction_pointer + 1, param1_mode)
        value_2 = value(result, instruction_pointer + 2, param2_mode)
        destination = Map.get(result, instruction_pointer + 3)

        result
        |> Map.put(destination, value_1 * value_2)
        |> process_opcode(instruction_pointer + 4, input, output, interrupt?)

      [3 = _store, _, _, _] ->
        destination = Map.get(result, instruction_pointer + 1)
        {input, remaining_input} = input(input)

        result
        |> Map.put(destination, input)
        |> process_opcode(instruction_pointer + 2, remaining_input, output, interrupt?)

      [4 = _output, _, _, param1_mode] ->
        value = value(result, instruction_pointer + 1, param1_mode)

        if interrupt? do
          {result, instruction_pointer + 2, value}
        else
          process_opcode(result, instruction_pointer + 2, input, [value | output], interrupt?)
        end

      [5 = _jump_if_true, _, param2_mode, param1_mode] ->
        condition = value(result, instruction_pointer + 1, param1_mode)

        if condition == 0 do
          process_opcode(result, instruction_pointer + 3, input, output, interrupt?)
        else
          jump_pointer = value(result, instruction_pointer + 2, param2_mode)
          process_opcode(result, jump_pointer, input, output, interrupt?)
        end

      [6 = _jump_if_false, _, param2_mode, param1_mode] ->
        condition = value(result, instruction_pointer + 1, param1_mode)

        if condition == 0 do
          jump_pointer = value(result, instruction_pointer + 2, param2_mode)
          process_opcode(result, jump_pointer, input, output, interrupt?)
        else
          process_opcode(result, instruction_pointer + 3, input, output, interrupt?)
        end

      [7 = _less_than, _, param2_mode, param1_mode] ->
        value_1 = value(result, instruction_pointer + 1, param1_mode)
        value_2 = value(result, instruction_pointer + 2, param2_mode)
        destination = Map.get(result, instruction_pointer + 3)

        value =
          if value_1 < value_2 do
            1
          else
            0
          end

        result
        |> Map.put(destination, value)
        |> process_opcode(instruction_pointer + 4, input, output, interrupt?)

      [8 = _equals, _, param2_mode, param1_mode] ->
        value_1 = value(result, instruction_pointer + 1, param1_mode)
        value_2 = value(result, instruction_pointer + 2, param2_mode)
        destination = Map.get(result, instruction_pointer + 3)

        value =
          if value_1 == value_2 do
            1
          else
            0
          end

        result
        |> Map.put(destination, value)
        |> process_opcode(instruction_pointer + 4, input, output, interrupt?)

      [99, _, _, _] ->
          # IO.inspect result

        {Map.get(result, 0), output}
    end
  end

  defp input([first, second]) do
    {first, second}
  end

  defp input(first) do
    {first, first}
  end

  defp value(result, position, 0 = _position_mode) do
    result[result[position]]
  end

  defp value(result, position, 1 = _immediate_mode) do
    result[position]
  end

  defp opcode(result, instruction_pointer) do
    [param3_mode, param2_mode, param1_mode, code1, code2] =
      result
      |> Map.get(instruction_pointer)
      |> to_string()
      |> String.pad_leading(5, "0")
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    [10 * code1 + code2, param3_mode, param2_mode, param1_mode]
  end
end
