defmodule AdventOfCode2020.Day12Test do
  use ExUnit.Case

  import AdventOfCode2020.Day12

  @tag :skip
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

  # @tag :skip
  test "part2" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    result = part2(input)

    assert result == 286
  end

  test "move_north" do
    state = %{
      direction: "E",
      east_west: {4, "E"},
      east_west_ship: {214, "E"},
      left: ["E", "N", "W", "S", "E", "N", "W", "S"],
      north_south: {10, "S"},
      north_south_ship: {72, "N"},
      right: ["E", "S", "W", "N", "E", "S", "W", "N"]
    }

    result = move_north(20, state)
    north_south = Map.get(result, :north_south)

    assert north_south == {10, "N"}
  end
end
