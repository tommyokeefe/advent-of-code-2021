defmodule AdventOfCode2020.Day03 do
  def part1(args) do
    mountain_face =
      String.split(args, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    height = Enum.count(mountain_face)
    width = Enum.count(Enum.at(mountain_face, 0))
    move(mountain_face, {width, height}, {0, 0}, {3, 1}, 0)
  end

  def part2(args) do
    mountain_face =
      String.split(args, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    height = Enum.count(mountain_face)
    width = Enum.count(Enum.at(mountain_face, 0))
    result = move(mountain_face, {width, height}, {0, 0}, {1, 1}, 0)
    result = move(mountain_face, {width, height}, {0, 0}, {3, 1}, 0) * result
    result = move(mountain_face, {width, height}, {0, 0}, {5, 1}, 0) * result
    result = move(mountain_face, {width, height}, {0, 0}, {7, 1}, 0) * result
    result = move(mountain_face, {width, height}, {0, 0}, {1, 2}, 0) * result
  end

  def move(
        mountain_face,
        {width, height},
        {horizontal_position, vertical_position},
        {horizontal_move, vertical_move},
        result
      ) do
    if vertical_position + 1 == height or vertical_position + vertical_move > height do
      result
    else
      horizontal_position = horizontal_position + horizontal_move
      vertical_position = vertical_position + vertical_move
      horizontal_position = rem(horizontal_position + 1, width) - 1
      location = Enum.at(Enum.at(mountain_face, vertical_position), horizontal_position)

      result = check_for_tree(location, result)

      move(
        mountain_face,
        {width, height},
        {horizontal_position, vertical_position},
        {horizontal_move, vertical_move},
        result
      )
    end
  end

  def check_for_tree(location, result) do
    case location do
      "#" -> result + 1
      _ -> result
    end
  end
end
