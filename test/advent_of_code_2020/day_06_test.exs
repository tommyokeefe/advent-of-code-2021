defmodule AdventOfCode2020.Day06Test do
  use ExUnit.Case

  import AdventOfCode2020.Day06

  @tag :skip
  test "part1" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    result = part1(input)

    assert result == 11
  end

  # @tag :skip
  test "part2" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    result = part2(input)

    assert result == 6
  end
end
