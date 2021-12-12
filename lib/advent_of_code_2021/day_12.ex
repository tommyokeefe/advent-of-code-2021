defmodule AdventOfCode.Day12 do
  def part1(args) do
    parse(args)
    |> count_paths()
  end

  def part2(args) do
    parse(args)
    |> count_paths(false)
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.reduce(%{}, fn line, connections ->
      [from | [to]] = String.split(line, "-", trim: true)

      Map.update(connections, from, [to], fn destinations -> [to | destinations] end)
      |> Map.update(to, [from], fn destinations -> [from | destinations] end)
    end)
  end

  def count_paths(caves, limit_visits? \\ true, current_cave \\ "start", visited \\ MapSet.new())

  def count_paths(_, _, "end", _) do
    1
  end

  def count_paths(caves, limit_visits?, current_cave, visited) do
    waypoints = Map.get(caves, current_cave)

    waypoints
    |> Enum.reject(&(&1 == "start"))
    |> Enum.map(fn waypoint ->
      cond do
        waypoint == String.downcase(waypoint) and waypoint in visited and limit_visits? ->
          0

        waypoint == String.downcase(waypoint) and waypoint in visited ->
          count_paths(caves, true, waypoint, MapSet.put(visited, waypoint))

        true ->
          count_paths(caves, limit_visits?, waypoint, MapSet.put(visited, waypoint))
      end
    end)
    |> Enum.sum()
  end
end
