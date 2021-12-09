defmodule AdventOfCode.Day09 do
  def part1(args) do
    lava_tubes = parse(args)

    Enum.sort(Map.keys(lava_tubes))
    |> Enum.reduce(0, fn item, acc -> get_risk_level(lava_tubes, item, acc) end)
  end

  def part2(args) do
    lava_tubes =
      parse(args)
      |> Enum.reject(fn {_key, value} -> value === 9 end)
      |> Map.new()

    locations =
      lava_tubes
      |> Enum.map(fn {key, _} -> {key, key} end)
      |> Map.new()

    Enum.reduce(locations, locations, fn {location, _}, acc ->
      get_neighbors(lava_tubes, location)
      |> Enum.reduce(acc, fn neighbor, acc ->
        get_union(acc, location, neighbor)
      end)
    end)
    |> Enum.group_by(fn {_, value} -> value end)
    |> Enum.map(fn {_, members} -> length(members) end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def get_neighbors(map, {row, col}) do
    [{row - 1, col}, {row, col - 1}, {row, col + 1}, {row + 1, col}]
    |> Enum.filter(&Map.has_key?(map, &1))
  end

  def get_union(union, location, neighbor) do
    case union do
      %{^location => value, ^neighbor => value} ->
        union

      %{^location => value1, ^neighbor => value2} ->
        Enum.reduce(union, union, fn
          {key, ^value1}, acc ->
            Map.put(acc, key, value2)

          _, acc ->
            acc
        end)
    end
  end

  def parse(data) do
    String.split(data, "\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, line_index}, map ->
      line
      |> Enum.with_index()
      |> Enum.reduce(map, fn {item, item_index}, acc ->
        Map.put(acc, {line_index, item_index}, String.to_integer(item))
      end)
    end)
  end

  def get_risk_level(lava_tubes, tube, acc) do
    risk = Map.get(lava_tubes, tube)
    {coord1, coord2} = tube

    adjacent_tubes = [
      Map.get(lava_tubes, {coord1 - 1, coord2}, 9),
      Map.get(lava_tubes, {coord1, coord2 + 1}, 9),
      Map.get(lava_tubes, {coord1 + 1, coord2}, 9),
      Map.get(lava_tubes, {coord1, coord2 - 1}, 9)
    ]

    cond do
      risk < Enum.min(adjacent_tubes) -> risk + 1 + acc
      true -> acc
    end
  end
end
