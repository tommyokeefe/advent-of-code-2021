defmodule AdventOfCode.Day11 do
  def part1(args) do
    build_grid(args) |> run_steps(100)
  end

  def part2(args) do
    grid = build_grid(args)

    grid_size = Enum.count(Map.keys(grid))
    run_steps_until(grid, grid_size)
  end

  def build_grid(data) do
    String.split(data, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, column_index}, map ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {value, row_index}, positions ->
        Map.put(positions, {column_index, row_index}, String.to_integer(value))
      end)
    end)
  end

  def run_steps(grid, count) do
    {_, total} =
      Enum.to_list(1..count)
      |> Enum.reduce({grid, 0}, fn _, {grid, total} ->
        {subtotal, grid} = run_step(grid)
        {grid, total + subtotal}
      end)

    total
  end

  def run_steps_until(grid, grid_size, run_count \\ 0) do
    run_count = run_count + 1
    {flashes, grid} = run_step(grid)

    cond do
      flashes == grid_size -> run_count
      true -> run_steps_until(grid, grid_size, run_count)
    end
  end

  def run_step(grid) do
    keys = Map.keys(grid) |> Enum.sort()

    Enum.reduce(keys, grid, fn key, grid ->
      {_, grid} =
        Map.get_and_update(grid, key, fn energy_level -> {energy_level, energy_level + 1} end)

      grid
    end)
    |> Enum.map(fn {key, value} -> {key, {value, false}} end)
    |> Map.new()
    |> check_flashes(keys)
    |> count_flashes(keys)
  end

  def check_flashes(grid, [key | keys]) do
    {value, flashed} = Map.get(grid, key)

    cond do
      value > 9 and !flashed ->
        do_flash(grid, key) |> check_flashes(keys)

      true ->
        check_flashes(grid, keys)
    end
  end

  def check_flashes(grid, []) do
    grid
  end

  def count_flashes(grid, keys) do
    flash_count =
      Enum.reduce(keys, 0, fn key, total ->
        {value, _} = Map.get(grid, key)

        cond do
          value > 9 -> total + 1
          true -> total
        end
      end)

    grid =
      Enum.map(grid, fn {key, {value, _}} ->
        cond do
          value > 9 -> {key, 0}
          true -> {key, value}
        end
      end)
      |> Map.new()

    {flash_count, grid}
  end

  def do_flash(grid, key) do
    {_, grid} =
      Map.get_and_update(grid, key, fn {value, flashed} -> {{value, flashed}, {value, true}} end)

    neighbors = get_neighbors(key)

    grid =
      Enum.reduce(neighbors, grid, fn neighbor, grid ->
        {_, grid} =
          Map.get_and_update(grid, neighbor, fn {energy_level, flashed} ->
            {{energy_level, flashed}, {energy_level + 1, flashed}}
          end)

        grid
      end)

    check_flashes(grid, neighbors)
  end

  def get_neighbors({c, r}) do
    Enum.filter(
      [
        {c - 1, r - 1},
        {c - 1, r},
        {c - 1, r + 1},
        {c, r - 1},
        {c, r + 1},
        {c + 1, r - 1},
        {c + 1, r},
        {c + 1, r + 1}
      ],
      fn {c, r} -> c >= 0 and c <= 9 and r >= 0 and r <= 9 end
    )
  end
end
