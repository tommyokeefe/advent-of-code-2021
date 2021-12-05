defmodule AdventOfCode.Day05 do
  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " -> ", trim: true) end)
    |> Enum.map(&get_coordinate_tuple_pairs/1)
    |> Enum.filter(&remove_diagonal_coordinates/1)
    |> find_vents
    |> get_count_of_dangerous_vents(2)
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " -> ", trim: true) end)
    |> Enum.map(&get_coordinate_tuple_pairs/1)
    |> find_vents
    |> get_count_of_dangerous_vents(2)
  end

  def get_coordinate_tuple_pairs(line) do
    raw_coordinate_one = String.split(Enum.at(line, 0), ",")

    coordinate_one = {
      String.to_integer(Enum.at(raw_coordinate_one, 0)),
      String.to_integer(Enum.at(raw_coordinate_one, 1))
    }

    raw_coordinate_two = String.split(Enum.at(line, 1), ",")

    coordinate_two = {
      String.to_integer(Enum.at(raw_coordinate_two, 0)),
      String.to_integer(Enum.at(raw_coordinate_two, 1))
    }

    [coordinate_one, coordinate_two]
  end

  def remove_diagonal_coordinates(coordinates) do
    [{x1, y1}, {x2, y2}] = coordinates
    x1 == x2 or y1 == y2
  end

  def find_vents(list_of_coordinate_pairs) do
    Enum.reduce(list_of_coordinate_pairs, %{}, fn coordinate_pair, positions ->
      line = get_line(coordinate_pair)
      set_positions(line, positions)
    end)
  end

  def get_line([{x1, y1}, {x2, y2}]) do
    cond do
      x1 == x2 -> get_line([{x1, y1}, {x2, y2}], :x)
      y1 == y2 -> get_line([{x1, y1}, {x2, y2}], :y)
      true -> get_line([{x1, y1}, {x2, y2}], :diagonal)
    end
  end

  def get_line([{x1, y1}, {x2, y2}], :x) do
    cond do
      y1 > y2 -> get_line([{x1, y1}, {x2, y2}], :y_ascending)
      y1 < y2 -> get_line([{x1, y1}, {x2, y2}], :y_descending)
      y1 == y2 -> ["#{x1}_#{y1}"]
    end
  end

  def get_line([{x1, y1}, {x2, y2}], :y) do
    cond do
      x1 > x2 -> get_line([{x1, y1}, {x2, y2}], :x_ascending)
      x1 < x2 -> get_line([{x1, y1}, {x2, y2}], :x_descending)
      x1 == x2 -> ["#{x1}_#{y1}"]
    end
  end

  def get_line([{x1, y1}, {x2, y2}], :diagonal) do
    cond do
      x1 > x2 -> get_line([{x1, y1}, {x2, y2}], :diagonal_ascending)
      x1 < x2 -> get_line([{x1, y1}, {x2, y2}], :diagonal_descending)
    end
  end

  def get_line([{x1, y1}, {x2, y2}], :y_ascending) do
    line = y1..y2

    Enum.map(line, fn item ->
      "#{x1}_#{item}"
    end)
  end

  def get_line([{x1, y1}, {x2, y2}], :y_descending) do
    line = y2..y1

    Enum.map(line, fn item ->
      "#{x1}_#{item}"
    end)
  end

  def get_line([{x1, y1}, {x2, y2}], :x_ascending) do
    line = x1..x2

    Enum.map(line, fn item ->
      "#{item}_#{y1}"
    end)
  end

  def get_line([{x1, y1}, {x2, y2}], :x_descending) do
    line = x2..x1

    Enum.map(line, fn item ->
      "#{item}_#{y1}"
    end)
  end

  def get_line([{x1, y1}, {x2, y2}], :diagonal_ascending) do
    line1 = x1..x2
    line2 = y1..y2
    line = Enum.zip(line1, line2)

    Enum.map(line, fn item ->
      "#{elem(item, 0)}_#{elem(item, 1)}"
    end)
  end

  def get_line([{x1, y1}, {x2, y2}], :diagonal_descending) do
    line1 = x2..x1
    line2 = y2..y1
    line = Enum.zip(line1, line2)

    Enum.map(line, fn item ->
      "#{elem(item, 0)}_#{elem(item, 1)}"
    end)
  end

  def set_positions(data, positions) do
    Enum.reduce(data, positions, fn item, positions ->
      {_, new_positions} =
        Map.get_and_update(positions, item, fn current_value ->
          cond do
            current_value == nil -> {current_value, 1}
            true -> {current_value, current_value + 1}
          end
        end)

      new_positions
    end)
  end

  def get_count_of_dangerous_vents(vents, danger_level) do
    vent_values = Map.values(vents)

    dangerous_vents =
      Enum.filter(vent_values, fn vent ->
        vent >= danger_level
      end)

    Enum.count(dangerous_vents)
  end
end
