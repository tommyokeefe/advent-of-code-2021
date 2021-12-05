defmodule AdventOfCode2020.Day05 do
  def part1(args) do
    rows = Enum.to_list(0..127)
    columns = Enum.to_list(0..7)

    passes =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        Enum.chunk_every(String.graphemes(line), 7, 7, [])
      end)

    seat_values =
      Enum.map(passes, fn pass ->
        calculate_seat_value(pass, rows, columns)
      end)

    Enum.max(seat_values)
  end

  def part2(args) do
    rows = Enum.to_list(0..127)
    columns = Enum.to_list(0..7)

    passes =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        Enum.chunk_every(String.graphemes(line), 7, 7, [])
      end)

    seat_values =
      Enum.map(passes, fn pass ->
        calculate_seat_value(pass, rows, columns)
      end)

    sorted_seat_values = Enum.sort(seat_values)
    get_seat(sorted_seat_values)
  end

  def calculate_seat_value([row_assignment | [column_assignment]], rows, columns) do
    multiplier = 8
    row_value = calculate_row(row_assignment, rows)
    column_value = calculate_column(column_assignment, columns)
    row_value * multiplier + column_value
  end

  def calculate_row(["F" | row_assignment], rows) do
    chunk_size = div(Enum.count(rows), 2)
    [rows | _] = Enum.chunk_every(rows, chunk_size)
    calculate_row(row_assignment, rows)
  end

  def calculate_row(["B" | row_assignment], rows) do
    chunk_size = div(Enum.count(rows), 2)
    [_ | [rows]] = Enum.chunk_every(rows, chunk_size)
    calculate_row(row_assignment, rows)
  end

  def calculate_row([], [value]) do
    value
  end

  def calculate_column(["L" | column_assignment], columns) do
    chunk_size = div(Enum.count(columns), 2)
    [columns | _] = Enum.chunk_every(columns, chunk_size)
    calculate_column(column_assignment, columns)
  end

  def calculate_column(["R" | column_assignment], columns) do
    chunk_size = div(Enum.count(columns), 2)
    [_ | [columns]] = Enum.chunk_every(columns, chunk_size)
    calculate_column(column_assignment, columns)
  end

  def calculate_column([], [value]) do
    value
  end

  def get_seat(seats) do
    min_seat = Enum.min(seats)
    max_seat = Enum.max(seats)
    all_seats = Enum.to_list(min_seat..max_seat)
    seat_set = MapSet.difference(MapSet.new(all_seats), MapSet.new(seats))
    [seat] = MapSet.to_list(seat_set)
    seat
  end
end
