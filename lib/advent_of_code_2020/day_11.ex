defmodule AdventOfCode2020.Day11 do
  def part1(args) do
    state = create_state(args)
    list = generate_list_from_state(state)
    run_until_stable(list, state, Enum.min(list), Enum.max(list), 0, nil)
  end

  def part2(args) do
    state = create_state(args)
    list = generate_list_from_state(state)
    run_until_stable(list, state, Enum.min(list), Enum.max(list), 0, :visible)
  end

  def create_state(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, line_index}, state ->
      line
      |> Enum.with_index()
      |> Enum.reduce(state, fn {location, location_index}, state ->
        Map.put(state, "#{line_index}.#{location_index}", location)
      end)
    end)
  end

  def generate_list_from_state(state) do
    Enum.sort(Map.keys(state))
    |> Enum.map(fn location ->
      String.split(location, ".")
      |> then(fn coordinate ->
        {String.to_integer(Enum.at(coordinate, 0)), String.to_integer(Enum.at(coordinate, 1))}
      end)
    end)
  end

  def run_until_stable(list, state, max, min, count, style) do
    count = count + 1
    new_state = run_seat_change(list, state, %{}, max, min, style)

    cond do
      new_state == state ->
        Map.values(new_state)
        |> Enum.count(fn item -> item == "#" end)

      true ->
        run_until_stable(list, new_state, max, min, count, style)
    end
  end

  def run_seat_change([item | list], state, new_state, min, max, style) do
    coord1 = elem(item, 0)
    coord2 = elem(item, 1)
    key = "#{coord1}.#{coord2}"
    value = Map.get(state, key)
    item = {item, min, max}
    new_state = apply_rules(item, key, value, state, new_state, style)
    run_seat_change(list, state, new_state, min, max, style)
  end

  def run_seat_change([], _state, new_state, _min, _max, _style) do
    new_state
  end

  def apply_rules(item, key, ".", state, new_state, _style) do
    Map.put(new_state, key, ".")
  end

  def apply_rules(item, key, "L", state, new_state, nil) do
    adjacent_seats = get_adjacent_seats(item, state)

    cond do
      Enum.member?(adjacent_seats, "#") -> Map.put(new_state, key, "L")
      true -> Map.put(new_state, key, "#")
    end
  end

  def apply_rules(item, key, "L", state, new_state, :visible) do
    adjacent_seat_count = get_visible_occupied_seats(item, state)

    cond do
      adjacent_seat_count > 0 -> Map.put(new_state, key, "L")
      true -> Map.put(new_state, key, "#")
    end
  end

  def apply_rules(item, key, "#", state, new_state, nil) do
    adjacent_seats = get_adjacent_seats(item, state)

    cond do
      Enum.count(adjacent_seats, fn seat -> seat == "#" end) >= 4 -> Map.put(new_state, key, "L")
      true -> Map.put(new_state, key, "#")
    end
  end

  def apply_rules(item, key, "#", state, new_state, :visible) do
    adjacent_seat_count = get_visible_occupied_seats(item, state)

    cond do
      adjacent_seat_count >= 5 -> Map.put(new_state, key, "L")
      true -> Map.put(new_state, key, "#")
    end
  end

  def get_adjacent_seats({{coord1, coord2}, {min1, min2}, {max1, max2}}, state) do
    [
      "#{coord1}.#{coord2 - 1}",
      "#{coord1 - 1}.#{coord2 - 1}",
      "#{coord1 - 1}.#{coord2}",
      "#{coord1 - 1}.#{coord2 + 1}",
      "#{coord1}.#{coord2 + 1}",
      "#{coord1 + 1}.#{coord2 + 1}",
      "#{coord1 + 1}.#{coord2}",
      "#{coord1 + 1}.#{coord2 - 1}"
    ]
    |> Enum.map(fn item -> Map.get(state, item, ".") end)
  end

  def get_visible_occupied_seats({{coord1, coord2}, _, _}, state) do
    count = 0
    count = get_seat_top_left(coord1, coord2, state, count)
    count = get_seat_top(coord1, coord2, state, count)
    count = get_seat_top_right(coord1, coord2, state, count)
    count = get_seat_right(coord1, coord2, state, count)
    count = get_seat_bottom_right(coord1, coord2, state, count)
    count = get_seat_bottom(coord1, coord2, state, count)
    count = get_seat_bottom_left(coord1, coord2, state, count)
    count = get_seat_left(coord1, coord2, state, count)
    count
  end

  def get_seat(coord1, coord2, state) do
    key = "#{coord1}.#{coord2}"
    Map.get(state, key, "L")
  end

  def get_seat_top_left(coord1, coord2, state, count) do
    coord1 = coord1 - 1
    coord2 = coord2 - 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_top_left(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_top(coord1, coord2, state, count) do
    coord1 = coord1 - 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_top(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_top_right(coord1, coord2, state, count) do
    coord1 = coord1 - 1
    coord2 = coord2 + 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_top_right(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_right(coord1, coord2, state, count) do
    coord1 = coord1
    coord2 = coord2 + 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_right(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_bottom_right(coord1, coord2, state, count) do
    coord1 = coord1 + 1
    coord2 = coord2 + 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_bottom_right(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_bottom(coord1, coord2, state, count) do
    coord1 = coord1 + 1
    coord2 = coord2
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_bottom(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_bottom_left(coord1, coord2, state, count) do
    coord1 = coord1 + 1
    coord2 = coord2 - 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_bottom_left(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end

  def get_seat_left(coord1, coord2, state, count) do
    coord1 = coord1
    coord2 = coord2 - 1
    value = get_seat(coord1, coord2, state)

    case value do
      "." -> get_seat_left(coord1, coord2, state, count)
      "L" -> count
      "#" -> count + 1
    end
  end
end
