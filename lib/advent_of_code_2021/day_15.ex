defmodule AdventOfCode.Day15 do
  def part1(args) do
    grid = parse(args)
    find_shortest_path(grid)
  end

  def part2(args) do
    grid = parse(args)
    {{x, y}, _} = Enum.max(grid)
    grid = enlarge(grid, x, y)
    find_shortest_path(grid)
  end

  def find_shortest_path(grid) do
    {start, _} = Enum.min(grid)
    {destination, _} = Enum.max(grid)
    next_steps = :gb_sets.singleton({0, start})
    visited = MapSet.new()
    find_shortest_path(grid, start, destination, next_steps, visited)
  end

  def find_shortest_path(grid, start, destination, next_steps, visited) do
    {{distance, point}, next_steps} = :gb_sets.take_smallest(next_steps)

    case point do
      ^destination ->
        distance

      _ ->
        visited = MapSet.put(visited, point)
        neighbors = get_neighbors(point, destination)

        next_steps =
          Enum.reduce(neighbors, next_steps, fn neighbor, next_steps ->
            cond do
              MapSet.member?(visited, neighbor) ->
                next_steps

              true ->
                priority = grid[neighbor] + distance
                :gb_sets.add_element({priority, neighbor}, next_steps)
            end
          end)

        find_shortest_path(grid, start, destination, next_steps, visited)
    end
  end

  def get_neighbors({x, y}, destination) do
    adjacent_deltas = [{0, -1}, {-1, 0}, {0, 1}, {1, 0}]
    {max_x, max_y} = destination

    for {delta_x, delta_y} <- adjacent_deltas,
        {new_x, new_y} = {x + delta_x, y + delta_y},
        new_x >= 0 and new_y >= 0 and new_x <= max_x and new_y <= max_y,
        do: {new_x, new_y}
  end

  def enlarge(map, max_x, max_y) do
    for x_factor <- 0..4,
        y_factor <- 0..4,
        reduce: map do
      new_map ->
        Map.merge(new_map, enlarged(map, x_factor, y_factor, max_x, max_y))
    end
  end

  defp enlarged(map, x_factor, y_factor, max_x, max_y) do
    for {{x, y}, risk} <- map, into: %{} do
      new_x = x + x_factor * (max_x + 1)
      new_y = y + y_factor * (max_y + 1)
      new_risk = risk + x_factor + y_factor
      new_risk = if new_risk <= 9, do: new_risk, else: new_risk - 9

      {{new_x, new_y}, new_risk}
    end
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn line ->
      String.to_charlist(line)
      |> Enum.map(&(&1 - ?0))
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      Enum.with_index(line)
      |> Enum.map(fn {point, column} -> {{row, column}, point} end)
    end)
    |> Map.new()
  end
end
