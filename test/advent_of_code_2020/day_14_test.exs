defmodule AdventOfCode2020.Day14Test do
  use ExUnit.Case

  import AdventOfCode2020.Day14

  @tag :skip
  test "part1" do
    input = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    result = part1(input)

    assert result == 165
  end

  @tag :skip
  test "part2" do
    input = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

    result = part2(input)

    assert result == 208
  end
end
