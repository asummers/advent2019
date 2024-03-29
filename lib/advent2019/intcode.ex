defmodule Advent2019.Intcode do
  def process_intcode(initial, input \\ 1) do
    process_intcode(initial, 0, input, [], false, 0)
  end

  def process_intcode(state, instruction_pointer, input, output, interrupt?, relative_base) do
    [opcode, param3_mode, param2_mode, param1_mode] = decode_opcode(state, instruction_pointer)

    case opcode do
      1 ->
        state
        |> add(instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base)
        |> process_intcode(instruction_pointer + 4, input, output, interrupt?, relative_base)

      2 ->
        state
        |> multiply(instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base)
        |> process_intcode(instruction_pointer + 4, input, output, interrupt?, relative_base)

      3 ->
        {input, remaining_input} = input(input)

        state
        |> store(instruction_pointer, input, param1_mode, relative_base)
        |> process_intcode(
          instruction_pointer + 2,
          remaining_input,
          output,
          interrupt?,
          relative_base
        )

      4 = _output ->
        value = value(state, instruction_pointer + 1, param1_mode, relative_base)

        if interrupt? do
          {state, instruction_pointer + 2, value}
        else
          process_intcode(
            state,
            instruction_pointer + 2,
            input,
            [value | output],
            interrupt?,
            relative_base
          )
        end

      5 ->
        jump_pointer =
          jump_if_true_jump_pointer(
            state,
            instruction_pointer,
            param1_mode,
            param2_mode,
            relative_base
          )

        process_intcode(state, jump_pointer, input, output, interrupt?, relative_base)

      6 ->
        jump_pointer =
          jump_if_false_jump_pointer(
            state,
            instruction_pointer,
            param1_mode,
            param2_mode,
            relative_base
          )

        process_intcode(state, jump_pointer, input, output, interrupt?, relative_base)

      7 ->
        state
        |> less_than(instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base)
        |> process_intcode(instruction_pointer + 4, input, output, interrupt?, relative_base)

      8 ->
        state
        |> equals(instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base)
        |> process_intcode(instruction_pointer + 4, input, output, interrupt?, relative_base)

      9 ->
        new_relative_base =
          value(state, instruction_pointer + 1, param1_mode, relative_base) + relative_base

        process_intcode(
          state,
          instruction_pointer + 2,
          input,
          output,
          interrupt?,
          new_relative_base
        )

      99 ->
        quit(state, output)
    end
  end

  defp add(state, instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base) do
    value_1 = value(state, instruction_pointer + 1, param1_mode, relative_base)
    value_2 = value(state, instruction_pointer + 2, param2_mode, relative_base)
    address = address(state, instruction_pointer + 3, param3_mode, relative_base)

    Map.put(state, address, value_1 + value_2)
  end

  defp multiply(state, instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base) do
    value_1 = value(state, instruction_pointer + 1, param1_mode, relative_base)
    value_2 = value(state, instruction_pointer + 2, param2_mode, relative_base)
    address = address(state, instruction_pointer + 3, param3_mode, relative_base)

    Map.put(state, address, value_1 * value_2)
  end

  defp store(state, instruction_pointer, input, param1_mode, relative_base) do
    address = address(state, instruction_pointer + 1, param1_mode, relative_base)

    Map.put(state, address, input)
  end

  defp jump_if_true_jump_pointer(
         state,
         instruction_pointer,
         param1_mode,
         param2_mode,
         relative_base
       ) do
    condition = value(state, instruction_pointer + 1, param1_mode, relative_base)

    if condition == 0 do
      instruction_pointer + 3
    else
      value(state, instruction_pointer + 2, param2_mode, relative_base)
    end
  end

  defp jump_if_false_jump_pointer(
         state,
         instruction_pointer,
         param1_mode,
         param2_mode,
         relative_base
       ) do
    condition = value(state, instruction_pointer + 1, param1_mode, relative_base)

    if condition == 0 do
      value(state, instruction_pointer + 2, param2_mode, relative_base)
    else
      instruction_pointer + 3
    end
  end

  defp less_than(state, instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base) do
    value_1 = value(state, instruction_pointer + 1, param1_mode, relative_base)
    value_2 = value(state, instruction_pointer + 2, param2_mode, relative_base)
    address = address(state, instruction_pointer + 3, param3_mode, relative_base)

    value =
      if value_1 < value_2 do
        1
      else
        0
      end

    Map.put(state, address, value)
  end

  defp equals(state, instruction_pointer, param1_mode, param2_mode, param3_mode, relative_base) do
    value_1 = value(state, instruction_pointer + 1, param1_mode, relative_base)
    value_2 = value(state, instruction_pointer + 2, param2_mode, relative_base)
    address = address(state, instruction_pointer + 3, param3_mode, relative_base)

    value =
      if value_1 == value_2 do
        1
      else
        0
      end

    Map.put(state, address, value)
  end

  defp quit(state, output) do
    {Map.get(state, 0), output}
  end

  defp input([first, second]) do
    {first, second}
  end

  defp input(first) do
    {first, first}
  end

  defp value(state, position, mode, relative_base) do
    address = address(state, position, mode, relative_base)
    Map.get(state, address, 0)
  end

  defp address(state, position, 0 = _position_mode, _relative_base) do
    Map.get(state, position)
  end

  defp address(_state, position, 1 = _immediate_mode, _relative_base) do
    position
  end

  defp address(state, position, 2 = _relative_mode, relative_base) do
    Map.get(state, position) + relative_base
  end

  defp decode_opcode(state, instruction_pointer) do
    [param3_mode, param2_mode, param1_mode, code1, code2] =
      state
      |> Map.get(instruction_pointer)
      |> to_string()
      |> String.pad_leading(5, "0")
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    [10 * code1 + code2, param3_mode, param2_mode, param1_mode]
  end
end
