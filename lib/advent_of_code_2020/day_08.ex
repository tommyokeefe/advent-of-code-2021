defmodule AdventOfCode2020.Day08 do
  def part1(args) do
    program =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        output = String.split(line, " ", trim: true)

        {Enum.at(output, 0), String.to_integer(Enum.at(output, 1))}
      end)

    run_program(program)
  end

  def part2(args) do
    program =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        output = String.split(line, " ", trim: true)

        {Enum.at(output, 0), String.to_integer(Enum.at(output, 1))}
      end)

    run_program(program, :fix)
  end

  def run_program(program) do
    run_program(program, 0, 0, [])
  end

  def run_program(program, :fix) do
    run_program(program, 0, 0, [], [], false)
  end

  def run_program(program, line, acc, lines_completed) do
    {instruction, step} = Enum.at(program, line)
    completed = Enum.find_value(lines_completed, nil, fn item -> item == line end)

    cond do
      completed == true ->
        acc

      instruction == "nop" ->
        run_program(program, line + 1, acc, [line | lines_completed])

      instruction == "jmp" ->
        run_program(program, line + step, acc, [line | lines_completed])

      instruction == "acc" ->
        run_program(program, line + 1, acc + step, [line | lines_completed])
    end
  end

  def run_program(program, line, acc, lines_completed, fixes_attempted, fix_tried_this_round) do
    is_last_line = line + 1 == Enum.count(program)

    {instruction, step} = Enum.at(program, line)
    looped = Enum.find_value(lines_completed, nil, fn item -> item == line end)
    fixed = Enum.find_value(fixes_attempted, nil, fn item -> item == line end)

    cond do
      looped == true ->
        run_program(program, 0, 0, [], fixes_attempted, false)

      is_last_line == true and instruction == "acc" ->
        acc + step

      is_last_line == true ->
        acc

      instruction == "nop" ->
        cond do
          fixed == true or fix_tried_this_round ->
            run_program(
              program,
              line + 1,
              acc,
              [line | lines_completed],
              fixes_attempted,
              fix_tried_this_round
            )

          true ->
            run_program(
              program,
              line + step,
              acc,
              [line | lines_completed],
              [
                line | fixes_attempted
              ],
              true
            )
        end

      instruction == "jmp" ->
        cond do
          fixed == true or fix_tried_this_round ->
            run_program(
              program,
              line + step,
              acc,
              [line | lines_completed],
              fixes_attempted,
              fix_tried_this_round
            )

          true ->
            run_program(
              program,
              line + 1,
              acc,
              [line | lines_completed],
              [
                line | fixes_attempted
              ],
              true
            )
        end

      instruction == "acc" ->
        run_program(
          program,
          line + 1,
          acc + step,
          [line | lines_completed],
          fixes_attempted,
          fix_tried_this_round
        )
    end
  end
end
