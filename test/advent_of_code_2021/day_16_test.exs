defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @tag :skip
  test "part1" do
    input = """
    620080001611562C8802118E34
    """
    result = part1(input)

    assert result == 12
  end

  @tag :skip
  test "part2" do
    input = """
    9C0141080250320F1802104A08
    """

    result = part2(input)

    assert result == 1
  end
end
