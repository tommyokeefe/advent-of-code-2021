defmodule AdventOfCode2020.Day12 do
  def part1(args) do
    state = get_original_state(:ship)
    input = parse(args)
    drive_ship(input, state)
  end

  def part2(args) do
    state = get_original_state(:waypoint)
    input = parse(args)
    drive_ship_with_waypoint(input, state)
  end

  def parse(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn item ->
      %{"direction" => direction, "value" => value} =
        Regex.named_captures(~r/(?<direction>[A-Z])(?<value>[0-9]+)/, item)

      {direction, String.to_integer(value)}
    end)
  end

  def get_original_state(style) do
    state = %{
      north_south: {0, "N"},
      east_west: {0, "E"},
      direction: "E",
      left: ["E", "N", "W", "S", "E", "N", "W", "S"],
      right: ["E", "S", "W", "N", "E", "S", "W", "N"]
    }

    case style do
      :ship ->
        state

      :waypoint ->
        Map.put(state, :north_south_ship, {0, "N"})
        |> Map.put(:east_west_ship, {0, "E"})
        |> Map.put(:north_south, {1, "N"})
        |> Map.put(:east_west, {10, "E"})
    end
  end

  def drive_ship([{direction, value} | input], state) do
    case direction do
      "N" -> drive_ship(input, move_north(value, state))
      "S" -> drive_ship(input, move_south(value, state))
      "E" -> drive_ship(input, move_east(value, state))
      "W" -> drive_ship(input, move_west(value, state))
      "L" -> drive_ship(input, turn_left(value, state, :ship))
      "R" -> drive_ship(input, turn_right(value, state, :ship))
      "F" -> drive_ship(input, go_forward(value, state, :ship))
    end
  end

  def drive_ship([], state) do
    {north_south, _} = Map.get(state, :north_south)
    {east_west, _} = Map.get(state, :east_west)
    north_south + east_west
  end

  def drive_ship_with_waypoint([{direction, value} | input], state) do
    case direction do
      "N" -> drive_ship_with_waypoint(input, move_north(value, state))
      "S" -> drive_ship_with_waypoint(input, move_south(value, state))
      "E" -> drive_ship_with_waypoint(input, move_east(value, state))
      "W" -> drive_ship_with_waypoint(input, move_west(value, state))
      "L" -> drive_ship_with_waypoint(input, turn_left(value, state, :waypoint))
      "R" -> drive_ship_with_waypoint(input, turn_right(value, state, :waypoint))
      "F" -> drive_ship_with_waypoint(input, go_forward(value, state, :waypoint))
    end
  end

  def drive_ship_with_waypoint([], state) do
    {north_south, _} = Map.get(state, :north_south_ship)
    {east_west, _} = Map.get(state, :east_west_ship)
    north_south + east_west
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

  def turn_left(degrees, state, :ship) do
    direction = Map.get(state, :direction)
    heading = Map.get(state, :left)
    index = Enum.find_index(heading, fn item -> item == direction end) + div(degrees, 90)
    Map.put(state, :direction, Enum.at(heading, index))
  end

  def turn_left(degrees, state, :waypoint) do
    heading = Map.get(state, :left)
    rotate(state, heading, degrees)
  end

  def turn_right(degrees, state, :ship) do
    direction = Map.get(state, :direction)
    heading = Map.get(state, :right)
    index = Enum.find_index(heading, fn item -> item == direction end) + div(degrees, 90)
    Map.put(state, :direction, Enum.at(heading, index))
  end

  def turn_right(degrees, state, :waypoint) do
    heading = Map.get(state, :right)
    rotate(state, heading, degrees)
  end

  def rotate(state, heading, degrees) do
    {distance1, bearing1} = Map.get(state, :north_south)
    {distance2, bearing2} = Map.get(state, :east_west)

    bearing1 =
      Enum.at(
        heading,
        Enum.find_index(heading, fn item -> item == bearing1 end) + div(degrees, 90)
      )

    bearing2 =
      Enum.at(
        heading,
        Enum.find_index(heading, fn item -> item == bearing2 end) + div(degrees, 90)
      )

    state
    |> update_bearing(distance1, bearing1)
    |> update_bearing(distance2, bearing2)
  end

  def go_forward(distance, state, :ship) do
    direction = Map.get(state, :direction)

    case direction do
      "N" -> move_north(distance, state)
      "S" -> move_south(distance, state)
      "E" -> move_east(distance, state)
      "W" -> move_west(distance, state)
    end
  end

  def go_forward(multiplier, state, :waypoint) do
    {distance1, bearing1} = Map.get(state, :north_south)
    {distance2, bearing2} = Map.get(state, :east_west)

    Map.update(state, :north_south_ship, {0, ""}, fn
      {value, ^bearing1} ->
        {distance1 * multiplier + value, bearing1}

      {value, ship_bearing} ->
        cond do
          value - distance1 * multiplier > 0 ->
            {value - distance1 * multiplier, ship_bearing}

          true ->
            {abs(value - distance1 * multiplier), bearing1}
        end
    end)
    |> Map.update(:east_west_ship, {0, ""}, fn
      {value, ^bearing2} ->
        {distance2 * multiplier + value, bearing2}

      {value, ship_bearing} ->
        cond do
          value - distance2 * multiplier > 0 ->
            {value - distance2 * multiplier, ship_bearing}

          true ->
            {abs(value - distance2 * multiplier), bearing2}
        end
    end)
  end

  def update_bearing(state, distance, bearing) when bearing == "E" or bearing == "W" do
    Map.put(state, :east_west, {distance, bearing})
  end

  def update_bearing(state, distance, bearing) when bearing == "N" or bearing == "S" do
    Map.put(state, :north_south, {distance, bearing})
  end
end
