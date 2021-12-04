defmodule AdventOfCode2020.Day03Test do
  use ExUnit.Case

  import AdventOfCode2020.Day03

  @tag :skip
  test "part1" do
    input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    result = part1(input)

    assert result == 7
  end

  @tag :skip
  test "part2" do
    input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    result = part2(input)

    assert result == 336
  end
end
