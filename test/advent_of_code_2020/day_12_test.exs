defmodule AdventOfCode2020.Day12Test do
  use ExUnit.Case

  import AdventOfCode2020.Day12

  # @tag :skip
  test "part1" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    result = part1(input)

    assert result == 25
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
