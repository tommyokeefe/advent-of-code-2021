defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @tag :skip
  test "part1" do
    input = "A0016C880162017C3686B18A3D4780"
    result = part1(input)

    assert result == 31
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
