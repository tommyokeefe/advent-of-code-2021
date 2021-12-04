defmodule AdventOfCode2020.Day02Test do
  use ExUnit.Case

  import AdventOfCode2020.Day02

  @tag :skip
  test "part1" do
    input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    result = part1(input)

    assert result == 2
  end

  @tag :skip
  test "part2" do
    input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    result = part2(input)

    assert result
  end
end
