defmodule AdventOfCode2020.Day09Test do
  use ExUnit.Case

  import AdventOfCode2020.Day09

  # @tag :skip
  test "part1" do
    input = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    result = part1(input, 5)

    assert result == 127
  end

  @tag :skip
  test "part2" do
    input = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    result = part2(input, 5)

    assert result == 62
  end
end
