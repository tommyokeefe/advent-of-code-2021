defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn item -> String.split(item, " ", trim: true) end)
    |> move_sub([0, 0])
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn item -> String.split(item, " ", trim: true) end)
    |> move_sub_with_aim([0, 0, 0])
  end

  def move_sub([["forward" | [steps]] | tail], [distance, depth]) do
    distance = distance + String.to_integer(steps)
    move_sub(tail, [distance, depth])
  end

  def move_sub([["down" | [steps]] | tail], [distance, depth]) do
    depth = depth + String.to_integer(steps)
    move_sub(tail, [distance, depth])
  end

  def move_sub([["up" | [steps]] | tail], [distance, depth]) do
    depth = depth - String.to_integer(steps)
    move_sub(tail, [distance, depth])
  end

  def move_sub([], [distance, depth]) do
    distance * depth
  end

  def move_sub_with_aim([["forward" | [steps]] | tail], [distance, depth, aim]) do
    distance = distance + String.to_integer(steps)
    depth = depth + aim * String.to_integer(steps)
    move_sub_with_aim(tail, [distance, depth, aim])
  end

  def move_sub_with_aim([["down" | [steps]] | tail], [distance, depth, aim]) do
    aim = aim + String.to_integer(steps)
    move_sub_with_aim(tail, [distance, depth, aim])
  end

  def move_sub_with_aim([["up" | [steps]] | tail], [distance, depth, aim]) do
    aim = aim - String.to_integer(steps)
    move_sub_with_aim(tail, [distance, depth, aim])
  end

  def move_sub_with_aim([], [distance, depth, _aim]) do
    distance * depth
  end
end
