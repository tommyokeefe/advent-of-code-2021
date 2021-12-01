defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = AdventOfCode.Input.get!(1)

    result = part1(input)

    assert result == 1374
  end

  test "part2" do
    input = AdventOfCode.Input.get!(1)
    result = part2(input)

    assert result == 1418
  end
end
