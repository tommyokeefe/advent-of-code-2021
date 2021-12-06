defmodule AdventOfCode2020.Day06 do
  def part1(args) do
    String.split(args, "\n\n", trim: true)
    |> Enum.map(fn line -> String.split(line, "\n", trim: true) end)
    |> Enum.reduce(0, &get_uniques/2)
  end

  def part2(args) do
    String.split(args, "\n\n", trim: true)
    |> Enum.map(fn line -> String.split(line, "\n", trim: true) end)
    |> Enum.map(fn line -> Enum.map(line, fn group -> String.split(group, "", trim: true) end) end)
    |> Enum.reduce(0, &get_shared_yes_answers/2)
  end

  def get_uniques(group, total) do
    group = Enum.map(group, fn member -> String.split(member, "", trim: true) end)
    flat_group = List.flatten(group)
    unique_group = Enum.uniq(flat_group)
    Enum.count(unique_group) + total
  end

  def get_shared_yes_answers([member | group], total) do
    get_shared_yes_answers(group, total, member)
  end

  def get_shared_yes_answers([member | group], total, shared) do
    intersection = MapSet.to_list(MapSet.intersection(MapSet.new(member), MapSet.new(shared)))
    count = Enum.count(intersection)

    cond do
      count >= 1 -> get_shared_yes_answers(group, total, intersection)
      true -> total
    end
  end

  def get_shared_yes_answers([], total, shared) do
    total + Enum.count(shared)
  end
end
