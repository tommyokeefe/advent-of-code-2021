defmodule AdventOfCode.Day17 do
  def part1(args) do
    input = parse(args)
    velocity_y = elem(input, 1)
    find_velocities(input, {0, velocity_y}, velocity_y)
    |> get_max()
  end

  def part2(args) do
    input = parse(args)
    velocity_y = elem(input, 1)
    find_velocities(input, {0, velocity_y}, velocity_y)
    |> Enum.count()
  end

  def find_velocities(input, velocity, current_y, hits \\ %{})

  def find_velocities({target, too_short, too_wide, max_velocity}, {x, y}, current_y, hits) do
    x = x + 1
    result = launch_probe(target, too_short, too_wide, max_velocity, {x, y})
    case result do
      :max ->
        hits
      :short ->
        find_velocities({target, too_short, too_wide, max_velocity}, {x, y}, current_y, hits)
      :wide ->
        find_velocities({target, too_short, too_wide, max_velocity}, {0, current_y + 1}, current_y + 1, hits)
      _ ->
        hits = Map.put(hits, {x, y}, result)
        find_velocities({target, too_short, too_wide, max_velocity}, {x, y}, current_y, hits)
    end
  end

  def launch_probe(target, too_short, too_wide, max_velocity, velocity, position \\ {0, 0}, highest_peak \\ 0) do
    {velocity, position} = do_probe_step(velocity, position)
    {x, y} = position
    highest_peak = if y > highest_peak, do: y, else: highest_peak
    cond do
      elem(velocity, 1) >= max_velocity -> :max
      MapSet.member?(target, position) -> highest_peak
      y < too_short -> :short
      x > too_wide -> :wide
      true -> launch_probe(target, too_short, too_wide, max_velocity, velocity, position, highest_peak)
    end
  end

  def do_probe_step({vx, vy}, {px, py}) do
    px = px + vx
    py = py + vy
    vy = vy - 1
    cond do
      vx > 0 -> {{vx - 1, vy}, {px, py}}
      vx < 0 -> {{vx + 1, vy}, {px, py}}
      vx == 0 -> {{0, vy}, {px, py}}
    end
  end

  def get_max(hits) do
    {position, max} = Enum.reduce(hits, {0,0}, fn {position, value}, {hp, hv} ->
      cond do
        value > hv -> {position, value}
        true -> {hp, hv}
      end
    end)

    IO.puts("highest value is #{max}")
    position
  end

  def parse(args) do
    [input|_] = String.split(args, "\n", trim: true)
    regex = ~r/target area: x=(?<min_x>[0-9]+)..(?<max_x>[0-9]+), y=(?<min_y>-[0-9]+)..(?<max_y>-[0-9]+)/
    ranges = Regex.named_captures(regex, input)
    target = MapSet.new()
    min_x = String.to_integer(Map.get(ranges, "min_x"))
    max_x = String.to_integer(Map.get(ranges, "max_x"))
    min_y = String.to_integer(Map.get(ranges, "min_y"))
    max_y = String.to_integer(Map.get(ranges, "max_y"))
    target = Enum.reduce(min_x..max_x, target, fn x, target ->
      Enum.reduce(min_y..max_y, target, fn y, target ->
        MapSet.put(target, {x, y})
      end)
    end)
    {target, min_y, max_x, abs(max_y) + max_x}
  end
end
