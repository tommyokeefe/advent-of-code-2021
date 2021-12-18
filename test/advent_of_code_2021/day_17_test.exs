defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @tag :skip
  test "part1" do
    input = """
    target area: x=20..30, y=-10..-5
    """
    result = part1(input)

    assert result == {6, 9}
  end

  @tag :skip
  test "part2" do
    input = """
    target area: x=20..30, y=-10..-5
    """
    result = part2(input)

    assert result == 112
  end
end
