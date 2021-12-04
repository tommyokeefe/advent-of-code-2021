defmodule AdventOfCode2020.Day01Test do
  use ExUnit.Case

  import AdventOfCode2020.Day01

  # @tag :skip
  test "part1" do
    input = """
    1721
    979
    366
    299
    675
    1456
    """

    result = part1(input)

    assert result == 514_579
  end

  # @tag :skip
  test "part2" do
    input = """
    1721
    979
    366
    299
    675
    1456
    """

    result = part2(input)

    assert result == 241_861_950
  end
end
