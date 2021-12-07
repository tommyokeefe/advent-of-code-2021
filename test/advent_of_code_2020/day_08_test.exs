defmodule AdventOfCode2020.Day08Test do
  use ExUnit.Case

  import AdventOfCode2020.Day08

  @tag :skip
  test "part1" do
    input = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

    result = part1(input)

    assert result == 5
  end

  @tag :skip
  test "part2" do
    input = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

    result = part2(input)

    assert result == 8
  end
end
