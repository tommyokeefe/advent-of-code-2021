defmodule AdventOfCode2020.Day12 do
  def part1(args) do
    state = get_original_state()
    input = parse(args)
    drive_ship(input, state)
  end

  def part2(args) do
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn item ->
      %{"direction" => direction, "value" => value} =
        Regex.named_captures(~r/(?<direction>[A-Z])(?<value>[0-9]+)/, item)

      {direction, String.to_integer(value)}
    end)
  end

  def drive_ship([{direction, value} | input], state) do
    case direction do
      "N" -> drive_ship(input, move_north(value, state))
      "S" -> drive_ship(input, move_south(value, state))
      "E" -> drive_ship(input, move_east(value, state))
      "W" -> drive_ship(input, move_west(value, state))
      "L" -> drive_ship(input, turn_left(value, state))
      "R" -> drive_ship(input, turn_right(value, state))
      "F" -> drive_ship(input, go_forward(value, state))
    end
  end

  def drive_ship([], state) do
    {north_south, _} = Map.get(state, :north_south)
    {east_west, _} = Map.get(state, :east_west)
    north_south + east_west
  end

  def get_original_state do
    %{
      north_south: {0, "N"},
      east_west: {0, "E"},
      direction: "E",
      left: ["E", "N", "W", "S", "E", "N", "W", "S"],
      right: ["E", "S", "W", "N", "E", "S", "W", "N"]
    }
  end

  def move_north(distance, state) do
    {value, direction} = Map.get(state, :north_south)

    cond do
      direction == "N" ->
        Map.put(state, :north_south, {value + distance, "N"})

      direction == "S" and value - distance > 0 ->
        Map.put(state, :north_south, {value - distance, "S"})

      true ->
        Map.put(state, :north_south, {abs(value - distance), "N"})
    end
  end

  def move_south(distance, state) do
    {value, direction} = Map.get(state, :north_south)

    cond do
      direction == "S" ->
        Map.put(state, :north_south, {value + distance, "S"})

      direction == "N" and value - distance > 0 ->
        Map.put(state, :north_south, {value - distance, "N"})

      true ->
        Map.put(state, :north_south, {abs(value - distance), "S"})
    end
  end

  def move_east(distance, state) do
    {value, direction} = Map.get(state, :east_west)

    cond do
      direction == "E" ->
        Map.put(state, :east_west, {value + distance, "E"})

      direction == "W" and value - distance > 0 ->
        Map.put(state, :east_west, {value - distance, "W"})

      true ->
        Map.put(state, :east_west, {abs(value - distance), "E"})
    end
  end

  def move_west(distance, state) do
    {value, direction} = Map.get(state, :east_west)

    cond do
      direction == "W" ->
        Map.put(state, :east_west, {value + distance, "W"})

      direction == "E" and value - distance > 0 ->
        Map.put(state, :east_west, {value - distance, "E"})

      true ->
        Map.put(state, :east_west, {abs(value - distance), "W"})
    end
  end

  def turn_left(degrees, state) do
    direction = Map.get(state, :direction)
    heading = Map.get(state, :left)
    index = Enum.find_index(heading, fn item -> item == direction end) + div(degrees, 90)
    Map.put(state, :direction, Enum.at(heading, index))
  end

  def turn_right(degrees, state) do
    direction = Map.get(state, :direction)
    heading = Map.get(state, :right)
    index = Enum.find_index(heading, fn item -> item == direction end) + div(degrees, 90)
    Map.put(state, :direction, Enum.at(heading, index))
  end

  def go_forward(distance, state) do
    direction = Map.get(state, :direction)

    case direction do
      "N" -> move_north(distance, state)
      "S" -> move_south(distance, state)
      "E" -> move_east(distance, state)
      "W" -> move_west(distance, state)
    end
  end
end
